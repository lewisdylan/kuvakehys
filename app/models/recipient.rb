class Recipient < ActiveRecord::Base
  belongs_to :group
  validates_presence_of :name, :address_1, :postal_code, :city
  has_many :recipient_orders, dependent: :destroy
  has_many :orders, through: :recipient_orders
end
