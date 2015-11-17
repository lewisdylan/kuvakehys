class UserMailer < ApplicationMailer
  default from: ENV['EMAIL_SENDER_ADDRESS']

  def email_processed(args={})
    @name = args[:email].from[:name]
    @email = args[:email].from[:email]
    @group = args[:group]
    @photos = args[:photos]
    @order = args[:order]

    mail(to: @email, from: @group.email_address, subject: 'Vielen Dank für deine E-Mail')
  end

  # only for users that already have sent in at least one photo
  def inactivity_notification(user)
    @user = user
    @photo = user.photos.last
    @group = @photo.group
    from = @group.email_address
    mail(to: user.email, from: from,  subject: 'Your photos are missed')
  end

  def new_order(order, user)
    @user = user
    @order = order
    mail(to: user.email, from: order.group.email_address, subject: 'A new package is on the way')
  end

  def login(email, groups)
    @groups = groups
    mail(to: email, subject: 'Tasveer.ew login link')
  end
end
