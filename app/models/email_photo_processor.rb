require 'openssl'
class EmailPhotoProcessor

  def initialize(email)
    @email = email
  end

  def process
    to_tokens = @email.to.collect { |e| e[:token] }
    user = User.find_or_create_by(email: @email.from[:email])
    user.update_attribute(:name, @email.from[:name]) unless user.name?
    group = Group.where(email: to_tokens).first!
    photos = @email.attachments.collect do |a|
      group.photos.create({
        user: user,
        picture: a,
        message_id: @email.headers["Message-ID"],
        subject: @email.subject,
        body: @email.body,
        sender_email: @email.from[:email],
        sender_name: @email.from[:name]
      })
    end
    order = group.has_enough_photos_for_a_new_order? ? group.orders.create(user: user, photos: group.photos.open) : nil
    UserMailer.email_processed(email: @email, group: group, photos: photos, order: order).deliver_now if photos.any?(&:valid?)
  end

  def verify(api_key, token, timestamp, signature)
    digest = OpenSSL::Digest::SHA256.new
    data = [timestamp, token].join
    signature == OpenSSL::HMAC.hexdigest(digest, api_key, data)
  end
end
