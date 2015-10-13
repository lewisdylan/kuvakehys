class WhatsappController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :set_ongair_message
  before_filter :validate_message_type

  def receive
    user = User.find_or_create_by(phone: @message.phone_number)

    if @message.type.message?
      if group = Group.find_by(email: @message.text)
        user.group = group
        user.save!
        message = "You have been added to the group #{group.email}. You can now send your pictures to be added there."
      else
        message = "Sorry group #{@message.text} does not exist. Go to http://tasveer.de if you want to create one."
      end
    elsif @message.type.image?
      if !user.group.nil?
        user.group.photos.create(user: user,  picture: @message.image, sender_name: @message.name)
        message = "Thanks #{@message.name}, your picture was successfully added to group #{user.group.email}. #{user.group.photos_missing_for_next_order} photos are missing for the next package."
      else
        message = "Hi #{@message.name}! Sorry, we could not identify your group. Please specify which group you want to add the picture to."
      end
    end
    Rails.logger.info(message)
    Ongair::Message.new(phone_number: user.phone, text: message).deliver!
    render text: 'ok'
  end


  private
    def validate_message_type
      if !@message.type.message? && !@message.type.image?
        render text: 'we do not care, but thanks'
      end
    end

    def set_ongair_message
      @message = Ongair::Message.new(params)
    end
end
