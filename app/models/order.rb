class Order < ActiveRecord::Base
  belongs_to :group
  has_many :photos

  def complete!
    AdminMailer.new_order(self).deliver_now
    order = PWINTY.Order.create_order(
      recipientName: order.group.recipient_name,
      address1: self.group.recipient_street,
      addressTownOrCity: self.group.recipient_city,
      postalOrZipCode: self.group.recipient_postal_code,
      stateOrCounty: '',
      countryCode: "UK",
      destinationCountryCode: 'DE',
      payment: "InvoiceMe",
      qualityLevel: "Standard"
    )
  end
end
