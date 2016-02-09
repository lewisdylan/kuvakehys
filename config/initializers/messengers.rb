#Ongair.configure {|c| c.token = ENV['ONGAIR_TOKEN'] } if ENV['ONGAIR_TOKEN']

#begin
  #TELEGRAM = Telegrammer::Bot.new(ENV['TELEGRAM_TOKEN']) if ENV['TELEGRAM_TOKEN']
#rescue Exception => e
#  Rails.logger.error("telgeram can not be initialized. Internet down?")
#  Rails.logger.error(e.message)
#end

