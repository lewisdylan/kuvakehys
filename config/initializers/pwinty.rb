if Rails.env.production?
  PWINTY = Pwinty.client(api_version: 'v2.2', merchant_id: ENV['PWINTY_MERCHANT_ID'], api_key: ENV['PWINTY_API_KEY'], production: ENV['PWINTY_PRODUCTION'] == 'true')
else
  class FakePwinty
    def create_order(args)
      {'id' => SecureRandom.hex(3)}
    end
    def add_photos(*args)
      true
    end
    def get_order_status(id)
      {'isValid' => (rand(5) > 0)}
    end
    def update_order_status(id, status)
      true
    end
  end
  PWINTY = FakePwinty.new
end

