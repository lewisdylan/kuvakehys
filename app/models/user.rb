class User < ActiveRecord::Base
  has_many :photos, dependent: :nullify

  has_many :memberships, dependent: :destroy
  has_many :collections, through: :memberships

  scope :inactive, -> { where(['last_upload_at IS NOT NULL and last_upload_at < ?', 3.weeks.ago]) }
  scope :with_email, -> { where('email IS NOT NULL') }

  validates_presence_of :device_id
  validates_uniqueness_of :device_id
  validates_uniqueness_of :email, allow_blank: true

  identify_with :usr

  def to_kitely_customer
    Kitely::Customer.new.tap do |c|
      c.shipping_address = {
        recipient_name: self.name,
        address_line_1: self.address_line_1,
        city: self.city,
        postcode: self.postcode,
        country_code: self.country_code
      }
      c.phone = self.phone
      c.email = self.email
    end
  end

  def mark_as_active!
    self.last_upload_at = Time.current
    self.last_inactivity_notifier_at = nil
    self.inactivity_notifications_count = 0
    self.save
  end

  def self.notify_inactive_users
    User.with_email.inactive.where(['(last_inactivity_notifier_at IS NULL OR last_inactivity_notifier_at < ?) AND (inactivity_notifications_count IS NULL OR inactivity_notifications_count < ?)', 2.weeks.ago, 3]).find_each do |user|
      UserMailer.inactivity_notification(user).deliver_now if user.inactivity_notifications_count.to_i < 3 # just to be sure
      user.update_attributes(last_inactivity_notifier_at: Time.now, inactivity_notifications_count: user.inactivity_notifications_count.to_i + 1)
    end
  end

  def as_json(args={})
    super(args.merge(only: [:name, :email, :identifier]))
  end
end
