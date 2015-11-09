class User < ActiveRecord::Base
	belongs_to :group
	has_many :photos, dependent: :nullify

  scope :inactive, -> { where(['last_import_at IS NOT NULL and last_import_at < ?', 2.weeks.ago]) }

  def self.notify_inactive_users
    User.inactive.where(['(last_inactivity_notifier_at IS NULL OR last_inactivity_notifier_at < ?) AND (inactivity_notifications_count IS NULL OR inactivity_notifications_count < ?)', 2.weeks.ago, 4]).find_each do |user|
      UserMailer.inactivity_notification(user).deliver_now
      user.update_attributes(last_inactivity_notifier_at: Time.now, inactivity_notifications_count: user.inactivity_notifications_count.to_i + 1)
    end
  end
end
