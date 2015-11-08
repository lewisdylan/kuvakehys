class UserMailer < ApplicationMailer
  default from: ENV['EMAIL_SENDER_ADDRESS']

  def email_processed(args={})
    @name = args[:email].from[:name]
    @email = args[:email].from[:email]
    @group = args[:group]
    @photos = args[:photos]
    @order = args[:order]

    mail(to: @email, subject: 'Vielen Dank für deine E-Mail')
  end
end
