class UserMailer < ApplicationMailer
  default from: ENV['EMAIL_SENDER_ADDRESS']

  def invitation
    @invitation = params[:invitation]
    mail(to: @invitation.email, subject: "You're invited to join an album")
  end
end
