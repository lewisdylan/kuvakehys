class Group < ActiveRecord::Base

  before_create :insert_defaults

  has_many :photos, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :users

  def photos_missing_for_next_order
    self.photo_limit - self.photos.open.count
  end

  def to_param
    email
  end

  def insert_defaults
    self.email ||= Haikunator.haikunate
    self.photo_limit ||= 25
  end

end
