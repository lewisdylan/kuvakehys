class Group < ActiveRecord::Base

  before_create :insert_defaults

  has_many :photos, dependent: :destroy
  has_many :orders, dependent: :destroy

  def photos_missing_for_next_order
    self.photo_limit - self.photos.open.count
  end

  def insert_defaults
    self.email ||= "#{self.name}-#{SecureRandom.hex(2)}"
    self.photo_limit ||= 20
  end
end
