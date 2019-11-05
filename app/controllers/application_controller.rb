class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :set_locale

  protected

  def authenticate
    user_id = params[:api_key] || request.headers['X-API-KEY']
    @current_user = User.find_by_mad_id(user_id) || User.find_by_device_id(user_id)
    if !user_id || !@current_user
      render json: "Not found", status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def set_locale
    I18n.locale = params[:locale] if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
  end

  def require_admin
    authenticate_or_request_with_http_basic("Application") do |name, password|
      name == ENV['ADMIN_USER'] && password == ENV['ADMIN_PASSWORD']
    end if Rails.env.production?
  end
end
