class Group < ActiveRecord::Base

  before_create :insert_defaults

  has_many :photos, dependent: :destroy
  has_many :orders, dependent: :destroy

  after_create :notify_owner

  def photos_missing_for_next_order
    self.photo_limit - self.photos.open.count
  end

  def to_param
    email
  end
  def insert_defaults
    self.email ||= "#{self.name}-#{SecureRandom.hex(2)}"
    self.photo_limit ||= 25
  end

  def notify_owner

  end
end
