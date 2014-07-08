module ApplicationHelper

  def support_locales
    @locales = {"en" => "English", "ko" => "한국어"}
  end

  def default_locale

    if signed_in?
      # logger.debug "* User Preference Language: #{current_user.locale}."
      I18n.locale = current_user.locale.to_sym
    end


    unless signed_in?
      support_locales # Get @locales, the supported language set
      if @locales.include?(browser_locale.to_s)
        # logger.debug "* User Browser Language: '#{browser_locale}' is supported, thus set."
        I18n.locale = browser_locale
      else
        # logger.debug "* User Browser Language: '#{browser_locale}' isn't supported, then set English as default."
        I18n.locale = :en
      end
    end

  end

  def browser_locale
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first.to_sym
  end

  def flash_normal
    render "flashes"
  end

  def bootstrap_flash(type)
    case type
      when :errors
        "alert-error"
      when :alert
        "alert-warning"
      when :error
        "alert-error"
      when :notice
        "alert-success"
      else
        "alert-info"
    end
  end

  #############################
  # Helper methods for Devise #
  #############################
  # make the devise resource mapping availble and understandable in places other than the devise views.
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
