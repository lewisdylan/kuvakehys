class Group < ActiveRecord::Base

  validates_presence_of :email
  validates_uniqueness_of :email

  before_create :insert_defaults

  has_many :photos, dependent: :destroy
  has_many :recipients, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :recipient_orders, dependent: :destroy

  accepts_nested_attributes_for :recipients
  identify_with :grp

  # we all love long method names, don't we?
  def has_enough_photos_for_a_new_order?
    self.photos.open.count >= self.photo_limit
  end

  def email_address
    "#{self.email}@#{ENV['SMTP_DOMAIN']}"
  end

  def recipient_names
    self.recipients.map(&:name).to_sentence
  end

  def photos_missing_for_next_order
    self.photo_limit - self.photos.open.count
  end


  def insert_defaults
    self.email ||= Haikunator.haikunate
    self.email.downcase!
    self.photo_limit ||= 25
  end

end
