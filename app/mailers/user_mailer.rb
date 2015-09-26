class UserMailer < ApplicationMailer
  default from: ENV['EMAIL_SENDER_ADDRESS']

  def email_processed(email, group)
    @name = email.from[:name]
    @email = email.from[:email]
    @group = group

    mail(to: @email, subject: 'Vielen Dank für deine E-Mail')
  end
end
