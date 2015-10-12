require 'openssl'
class EmailPhotoProcessor

  def initialize(email)
    @email = email
  end

  def process
    to_tokens = @email.to.collect { |e| e[:token] }
    group = Group.where(email: to_tokens).first!
    photos = @email.attachments.collect do |a|
      group.photos.create({
        picture: a,
        message_id: @email.headers["Message-ID"],
        subject: @email.subject,
        body: @email.body,
        sender_email: @email.from[:email],
        sender_name: @email.from[:name]
      })
    end
    UserMailer.email_processed(@email, group).deliver_now if photos.any?(&:valid?)
  end

  def verify(api_key, token, timestamp, signature)
    digest = OpenSSL::Digest::SHA256.new
    data = [timestamp, token].join
    signature == OpenSSL::HMAC.hexdigest(digest, api_key, data)
  end
end
