class User < ActiveRecord::Base
	belongs_to :group
	has_many :photos, dependent: :nullify

  scope :inactive, -> { where(['last_import_at IS NOT NULL and last_import_at < ?', 2.weeks.ago]) }
  scope :with_email, -> { where('email IS NOT NULL') }

  def mark_as_active!
    self.last_import_at = Time.now
    self.last_inactivity_notifier_at = nil
    self.inactivity_notifications_count = 0
    self.save
  end

  def self.notify_inactive_users
    User.with_email.inactive.where(['(last_inactivity_notifier_at IS NULL OR last_inactivity_notifier_at < ?) AND (inactivity_notifications_count IS NULL OR inactivity_notifications_count < ?)', 2.weeks.ago, 4]).find_each do |user|
      UserMailer.inactivity_notification(user).deliver_now if user.inactivity_notifications_count.to_i < 4 # just to be sure
      user.update_attributes(last_inactivity_notifier_at: Time.now, inactivity_notifications_count: user.inactivity_notifications_count.to_i + 1)
    end
  end
end
