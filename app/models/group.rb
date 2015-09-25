class Group < ActiveRecord::Base

  before_create :insert_email

  has_many :photos, dependent: :destroy
  has_many :orders, dependent: :destroy

  def insert_email
    self.email ||= "#{self.name}-#{SecureRandom.hex(2)}"
  end
end
