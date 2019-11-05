require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kuvakehys
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    config.active_storage.variant_processor = :mini_magick

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    #config.lograge.enabled = true
    #config.lograge.formatter = Class.new do |fmt|
    #  def fmt.call(data)
    #    { msg: "Request" }.merge(data)
    #  end
    #end
    #config.lograge.base_controller_class = 'ActionController::Base'
    #config.lograge.custom_payload do |controller|
    #  {
    #    host: controller.request.host,
    #    user_id: controller.try(:current_user).try(:id),
    #    request_id: controller.request.request_id
    #  }
    #end

    #require Rails.root.join('lib/tasveer_logger.rb')
    #config.logger = TasveerLogger.new(STDOUT)
    #config.lograge.logger = config.logger
  end
end
