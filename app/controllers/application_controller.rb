class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected

  def require_admin
    authenticate_or_request_with_http_basic("Application") do |name, password|
      name == ENV['ADMIN_USER'] && password == ENV['ADMIN_PASSWORD']
    end if Rails.env.production?
  end
end
