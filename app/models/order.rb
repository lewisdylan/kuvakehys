class Order < ActiveRecord::Base
  belongs_to :group
  has_many :photos

  def complete!
    AdminMailer.new_order(self).deliver_now
    create_order
    add_photos
    validate_and_submit_order
  end

  def create_order
    order = PWINTY.create_order(
      recipientName: self.group.recipient_name,
      address1: self.group.recipient_street,
      addressTownOrCity: self.group.recipient_city,
      postalOrZipCode: self.group.recipient_postal_code,
      stateOrCounty: '',
      countryCode: self.group.recipient_country,
      destinationCountryCode: self.group.recipient_country,
      payment: "InvoiceMe",
      qualityLevel: "Standard"
    )
    Rails.logger.info("order##{self.id} submitted order #{order.inspect}")
    self.update_attribute(:print_order_id, order['id'])
  end

  def add_photos
    PWINTY.add_photos(self.print_order_id, self.photos.map(&:to_order))
  end

  def validate_and_submit_order
    order_status = PWINTY.get_order_status(self.print_order_id)
    if order_status['isValid']
      PWINTY.update_order_status(self.print_order_id, 'Submitted')
      Rails.logger.info("order##{self.id} updated order status to Submitted")
    else
      Rails.logger.error("order##{self.id} not submitted. status=#{order_status}")
    end
  end
end
