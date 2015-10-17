class Group < ActiveRecord::Base

  validates_presence_of :email
  validates_uniqueness_of :email

  before_create :insert_defaults

  has_many :photos, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :users, dependent: :destroy


  def photos_missing_for_next_order
    self.photo_limit - self.photos.open.count
  end

  def to_param
    email
  end

  def insert_defaults
    self.email ||= Haikunator.haikunate
    self.email.downcase!
    self.photo_limit ||= 25
  end

end
