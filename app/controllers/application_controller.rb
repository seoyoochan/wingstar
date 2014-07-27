class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # instead of completely turning off the built in security,
  # kills off any session that might exist when something hits the
  # server without the CSRF token.
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  protect_from_forgery with: :exception

  before_filter :configure_devise_params, if: :devise_controller?
  before_filter :default_locale, :ws_locales


  protected
  def configure_devise_params
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :date_of_birth, :locale, :gender) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :agreement, :date_of_birth, :locale, :gender) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
  end

end
