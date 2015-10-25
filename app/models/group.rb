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

  def printing_country
    # manually compilled list from the pwinty countries endpoint
    if ['AT', 'AU', 'BE', 'BR', 'CA', 'CH', 'CL', 'DE', 'DK', 'ES', 'FR', 'GB', 'IE', 'IT', 'MX', 'NL', 'NO', 'RO', 'SE', 'US'].include?(self.recipient_country)
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
