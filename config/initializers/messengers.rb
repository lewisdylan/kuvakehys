Ongair.configure {|c| c.token = ENV['ONGAIR_TOKEN'] } if ENV['ONGAIR_TOKEN']

TELEGRAM = Telegrammer::Bot.new(ENV['TELEGRAM_TOKEN']) if ENV['TELEGRAM_TOKEN']

