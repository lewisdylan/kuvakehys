class WhatsappController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    Rails.logger.info("whatsapp here")
    Rails.logger.info(params)
    render text: 'hello ongair'
  end
end
