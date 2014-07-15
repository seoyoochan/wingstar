class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :default_locale, :support_locales
  before_filter :configure_devise_params, if: :devise_controller?

  protected
  def configure_devise_params
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :date_of_birth, :locale, :gender) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :agreement, :date_of_birth, :locale, :gender) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password) }
  end



end
