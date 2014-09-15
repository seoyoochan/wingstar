module ApplicationHelper

  def ws_locales
    @locales = {"en" => "English (US)" , "ko" => "한국어",}
  end

  def current_locale
    ws_locales[I18n.locale.to_s]
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
    ws_locales
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
      when "warning" then "alert-warning"
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

  def br3_icon(name)
    "<span class='glyphicon glyphicon-#{name}'></span>".html_safe
  end

  def name_mapper(current_user=nil)

    if current_user.nil?
      return nil
    end
    eastern_format = "#{current_user.last_name}#{current_user.first_name}" if current_user.locale == "ko"
    western_format = "#{current_user.first_name} #{current_user.last_name}" if current_user.locale == "en"

    # 1. user's name exists?
    if current_user.name
      current_user.name
    else
      # 2. then his favorite name format exists?
      if current_user.name_format.present?
        if current_user.name_format == "eastern"
          eastern_format
        else
          western_format
        end
      else
        # 3. then his locale exists?

        case current_user.locale
          when "en" then western_format
          when "ko" then eastern_format
          else western_format
        end

      end
    end
  end

  def sns_provider
    session[:current_user_provider] if session[:current_user_provider]
  end

  def sns_provider_uid
    session[:current_user_provider_uid] if session[:current_user_provider_uid]
  end

  def blog_link_provider(user)
    if user == current_user
      if user.blog.present?
        "/blog/#{user.username}"
      else
        new_blog_path
      end
    else
      if user.blog.present?
        "/blog/#{user.username}"
      else
        :back
      end
    end
  end

  def parsed_user
    @parsed_user =
    if request.params[:username].present?
      parsed_user = User.find_by(username: "#{params[:username]}")
    else
      current_user
    end
  end

  def redirect_back
    session[:return_to] ||= request.referer
    logger.debug "request.referer: #{request.referer}"
    redirect_to session.delete(:return_to)
  end

  def required?(obj, attr)
    target = (obj.class == Class) ? obj : obj.class
    target.validators_on(attr).map(&:class).include?(ActiveModel::Validations::PresenceValidator)
  end

  def parsed_address
    if @parsed_user && @parsed_user.location.present? && @parsed_user.location.address.present?
      @parsed_address = Geocoder.search("#{@parsed_user.location.address}", params: {language: I18n.locale }).first.data["formatted_address"]
    else
      nil
    end
  end

end
