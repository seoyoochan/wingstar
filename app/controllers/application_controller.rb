class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # instead of completely turning off the built in security,
  # kills off any session that might exist when something hits the
  # server without the CSRF token.
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  protect_from_forgery with: :exception

  # To fix the problem with ajax requests
  # skip_before_filter :verify_authenticity_token, :only => [:name_of_your_action]

  before_filter :configure_devise_params, if: :devise_controller?
  before_filter :default_locale, :ws_locales
  before_filter :user_activity
  before_filter :parsed_user
  before_filter :parsed_address
  around_filter :set_time_zone
  before_filter :profile_cover_build
  before_filter :current_or_guest_user

  public

  def index
    render "layouts/application"
  end

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        logging_in
        guest_user.destroy
        session[:guest_user_id] = nil
      end
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user
  end

  protected
  def configure_devise_params
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :username, :date_of_birth, :locale, :gender, :website, :profile_image, :avatar, :avatar_cache, :job, :description, :skill_list, :interest_list, :tag_list, :location) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :username, :agreement, :date_of_birth, :locale, :gender, :website, :profile_image, :avatar, :avatar_cache, :job, :description,:skill_list, :interest_list, :tag_list, :location) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
  end

  def user_activity
    current_user.try :touch
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  # def after_sign_out_path_for(resource_or_scope)
  #   root_path
  # end

  private
  def set_time_zone
    default_timezone = Time.zone
    client_timezone  = cookies["jstz_time_zone"]
    Time.zone = client_timezone if client_timezone.present?
    yield
  ensure
    Time.zone = default_timezone
  end

  def profile_cover_build
    current_user.profile.attachments.build if (params["controller"] == "application") && (params["action"] == "index") && signed_in?
  end

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
    # comment.user_id = current_user.id
    # comment.save!
    # end
  end

  def create_guest_user
    u = User.new(username: "guest#{Time.now.to_i}#{rand(1000)}", email: "guest_#{Time.now.to_i}#{rand(100)}@example.com", current_sign_in_ip: request.remote_ip, last_sign_in_ip: request.remote_ip)
    u.skip_confirmation!
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end

end
