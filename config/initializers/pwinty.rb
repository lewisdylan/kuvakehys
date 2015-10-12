PWINTY = Pwinty.client(api_version: 'v2.2', merchant_id: ENV['PWINTY_MERCHANT_ID'], api_key: ENV['PWINTY_API_KEY'], production: ENV['PWINTY_PRODUCTION'] == 'true')
