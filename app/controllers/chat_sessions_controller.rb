class ChatSessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :validate_whatsapp_message_type, only: [:whatsapp]

  def telegram
    @update = Telegrammer::DataTypes::Update.new(
      update_id: params[:update_id],
      message: params[:message]
    )
    @message = @update.message

    @photo = @update.message.photo.sort {|a, b| a.file_size <=> b.file_size }.last

    user = User.find_or_create_by(telegram_id: @message.from.id.to_s)
    user.update_attributes(last_import_at: Time.now, name: "#{@message.from.first_name} #{@message.from.last_name}")

    if @message.text.present?
      if @message.text == '/start'
        reply = "Hi #{@message.from.first_name}, welcome to tasveer on telegram. To which group do you want to send pictures?"
      elsif group = Group.find_by(email: @message.text.downcase)
        user.group = group
        user.save!
        reply = "You have been added to the group #{group.email}. You can now send your pictures to be added there."
      else
        reply = "Sorry group #{@message.text} does not exist. Go to http://tasveer.de if you want to create one."
      end
    end
    if @photo
      if !user.group.nil?
        @picture_url = TELEGRAM.get_file(file_id: @photo.file_id)
        user.group.photos.create(user: user,  picture: @picture_url, sender_name: "#{@message.from.first_name} #{@message.from.last_name}")
        reply = "Thanks #{@message.from.first_name}, your picture was successfully added to group #{user.group.email}. #{user.group.photos_missing_for_next_order} photos are missing for the next package."
      else
        reply = "Hi #{@message.from.first_name}! Sorry, we could not identify your group. Which group do you want to send the picture to?"
      end
    end
    args = { chat_id: @message.chat.id, text: reply}
    TELEGRAM.send_message(args)

    render text: 'ok'
  end


  def whatsapp
    @message = Ongair::Message.new(params)
    user = User.find_or_create_by(phone: @message.phone_number)
    user.update_attribute(:name, @message.name) unless user.name?

    if @message.type.message?
      if group = Group.find_by(email: @message.text.downcase)
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
        message = "Hi #{@message.name}! Sorry, we could not identify your group. Which group do you want to send the picture to?"
      end
    end
    Rails.logger.info(message)
    Ongair::Message.new(phone_number: user.phone, text: message).deliver!
    render text: 'ok'
  end


  private
    def validate_whatsapp_message_type
      if !@message.type.message? && !@message.type.image?
        render text: 'we do not care, but thanks'
      end
    end

end
