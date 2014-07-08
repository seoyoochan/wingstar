class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
  
  before_action :default_locale, :support_locales

end