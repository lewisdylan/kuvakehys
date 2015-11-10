class SessionsController < ApplicationController

  def new
  end

  def create
    email = params[:email].to_s.strip.downcase
    groups = Group.where(owner_email: email)
    UserMailer.login(email, groups).deliver_now if groups.any?
    redirect_to root_url, notice: 'We have sent you an email with details to manage your group'
  end
end
