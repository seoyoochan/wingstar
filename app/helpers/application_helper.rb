module ApplicationHelper

  def app_locale_set
    @locales = {"en" => "English" , "ko" => "한국어"}
  end

  def default_locale

    if signed_in?
      logger.debug "* User Preference Language: #{current_user.locale}."
      I18n.locale = current_user.locale.to_sym # User locale is the highest priority
    else
      # Set locale by browser language
      available_locale(browser_locale)
      # Otherwise, set locale if locale passed from url
      available_locale(params[:locale]) if params[:locale].present?
    end
  end

  def browser_locale
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first.to_sym
  end

  def available_locale(source)
    app_locale_set
    if @locales.include?(source.to_s)
      logger.debug "* Language: '#{source}' was set."
      I18n.locale = source
    else
      logger.debug "* Language: '#{source}' isn't supported, then set English as default."
      I18n.locale = :en

      flash[:error] = "#{source.to_s} " + t("unfound_locale")

      redirect_to root_path
    end
  end

  def bootstrap_flash(type)
    case type
      when "notice" then "alert-info"
      when "info" then "alert-info"
      when "success" then "alert-success"
      when "error" then "alert-danger"
      when "alert" then "alert-danger"
      else type.to_s
    end
  end

  #############################
  # Helper methods for Devise #
  #############################
  # make the devise resource mapping available and understandable in places other than the devise views.
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
