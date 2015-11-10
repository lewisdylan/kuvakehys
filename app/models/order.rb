class Order < ActiveRecord::Base
  belongs_to :group
  has_many :photos
  has_many :recipient_orders
  has_many :recipients, through: :recipient_orders
  has_many :users, through: :photos
  belongs_to :user

  after_create :create_recipient_orders
  after_create :notify_admin
  after_create :notify_users

  def submitted?
    self.status == 'submitted'
  end

  def submit!
    create_order unless self.print_order_id.present?
    add_photos if self.status == 'order_created'
    validate_and_submit_order if self.status == 'photos_added'
  end

  def create_order
    Rails.logger.error("order##{self.id}: creating orders")
    self.recipient_orders.each do |ro|
      ro.create_order
    end
  end

  def add_photos
    Rails.logger.error("order##{self.id}: adding photos")
    self.recipient_orders.each do |ro|
      ro.add_photos
    end
  end

  def validate_and_submit_order
    Rails.logger.error("order##{self.id}: submitting")
    self.recipient_orders.each do |ro|
      ro.validate_and_submit_order
    end
  end

  def notify_admin
    AdminMailer.new_order(self).deliver_now
  end

  def notify_users
    self.users.where.not(id: self.user.try(:id)).uniq.each do |u|
      UserMailer.new_order(self, u).deliver_now
    end
  end

  def create_recipient_orders
    if self.group.blank?
      Rails.logger.error('order##{self.id}: no group id present. ignoring.')
      return
    end
    self.group.recipients.each do |recipient|
      self.recipient_orders.create(recipient: recipient, group: self.group)
    end
  end
end
