class RecipientOrder < ActiveRecord::Base

  belongs_to :group
  belongs_to :recipient
  belongs_to :order

  # international shipping means that we are shipping to a country that has no printing facility.
  # thus also the printing company must be GB see #printing_country
  def international_shipping?
    # this is a manually picked list from the pwinty countries endpoint. these countries "haveProducts" meaning they have local printing facilities
    !['AT', 'AU', 'BE', 'BR', 'CA', 'CH', 'CL', 'DE', 'DK', 'ES', 'FR', 'GB', 'IE', 'IT', 'MX', 'NL', 'NO', 'RO', 'SE', 'US'].include?(self.recipient.country)
  end

  def printing_country
    # see #international_shipping?
    if !international_shipping?
      self.recipient.country
    else
      'GB' #international shipping from GB
    end
  end


  def create_order
    return false if self.print_order_id.present?
    order = PWINTY.create_order(
      recipientName: self.recipient.name,
      address1: self.recipient.address_1,
      address2: self.recipient.address_2,
      addressTownOrCity: self.recipient.city,
      postalOrZipCode: self.recipient.postal_code,
      stateOrCounty: '',
      countryCode: self.printing_country,
      destinationCountryCode: self.recipient.country,
      payment: "InvoiceMe",
      qualityLevel: (self.international_shipping? ? "Pro" : "Standard") # only Pro can ship internationally
    )
    Rails.logger.info("recipient_order##{self.id} submitted order #{order.inspect}")
    self.update_attribute(:print_order_id, order['id'])
    self.update_attribute(:status, 'order_created')
  end

  def add_photos
    return false unless self.status == 'order_created'
    PWINTY.add_photos(self.print_order_id, self.order.photos.map {|m| m.to_order(self.recipient.country) })
    self.update_attribute(:status, 'photos_added')
  end

  def validate_and_submit_order
    return false unless self.status == 'photos_added'
    order_status = PWINTY.get_order_status(self.print_order_id)
    if order_status['isValid']
      PWINTY.update_order_status(self.print_order_id, 'Submitted')
      Rails.logger.info("recipient_order##{self.id} updated order status to Submitted")
      self.update_attribute(:status, 'submitted')
      true
    else
      Rails.logger.error("recipient_order##{self.id} not submitted. status=#{order_status}")
      false
    end
  end



end
