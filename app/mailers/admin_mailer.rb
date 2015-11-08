class AdminMailer < ApplicationMailer
  default from: ENV['EMAIL_SENDER_ADDRESS']

  def new_order(order)
    @order = order
    mail(to: ENV['ADMIN_EMAIL'], subject: 'yay, a new order!')
  end

end
