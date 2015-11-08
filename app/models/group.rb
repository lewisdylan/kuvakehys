class Group < ActiveRecord::Base

  validates_presence_of :email
  validates_uniqueness_of :email

  before_create :insert_defaults

  has_many :photos, dependent: :destroy

  has_many :orders, dependent: :destroy
  has_many :users, dependent: :destroy

  identify_with :grp

  # we all love long method names, don't we?
  def has_enough_photos_for_a_new_order?
    self.photos.open.count >= self.photo_limit
  end

  def email_address
    "#{self.email}@#{ENV['SMTP_DOMAIN']}"
  end

  def photos_missing_for_next_order
    self.photo_limit - self.photos.open.count
  end

  # international shipping means that we are shipping to a country that has no printing facility.
  # thus also the printing company must be GB see #printing_country
  def international_shipping?
    # this is a manually picked list from the pwinty countries endpoint. these countries "haveProducts" meaning they have local printing facilities
    !['AT', 'AU', 'BE', 'BR', 'CA', 'CH', 'CL', 'DE', 'DK', 'ES', 'FR', 'GB', 'IE', 'IT', 'MX', 'NL', 'NO', 'RO', 'SE', 'US'].include?(self.recipient_country)
  end

  def printing_country
    # see #international_shipping?
    if !international_shipping?
      self.recipient_country
    else
      'GB' #international shipping from GB
    end
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
