class Invitation < ActiveRecord::Base
  belongs_to :collection
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :user

  validates_presence_of :sender_id, :collection_id, :email

  after_create :notify_user

  identify_with :inv

  def as_json(args={})
    h = super(only: [:accepted_at, :identifier, :email])
    h.merge({
      collection_id: self.collection.identifier,
      sender_id: self.sender.identifier,
      user_id: self.user.try(:identifier)
    })
  end

  def accept(user)
    return false if self.accepted_at.present?
    self.user = user
    self.accepted_at = Time.current
    self.collection.memberships.create(user: user, invitation: self)
    self.save
  end

  def lookup_user
    self.user = User.find_by_email(self.email)
  end

  def notify_user
    UserMailer.with(invitation: self).invitation.deliver_now
  end
end
