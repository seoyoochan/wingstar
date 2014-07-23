class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :authenticate_user!

  def add_email
    data = session["devise.omniauth_data"]
    data[:email] = params[:user][:email]
    user = User.add_email_identity(data)
    if user.persisted?
      flash[:success] = "이메일 등록이 완료되었습니다."
      redirect_to root_path
    else
      flash[:error] = "정보가 저장되지 못했습니다."
      render "users/omniauth_callbacks/add_email"
    end
  end

  def all
    auth = request.env["omniauth.auth"]
    sns_provider = auth.provider.humanize

    if current_user

       @identity = User.from_omniauth(auth, current_user)
       logger.debug " * @identity  : #{@identity}"
       if @identity.changed?
         if @identity.save!(:validate => false)
           flash[:success] = "#{sns_provider} 계정이 연결되었습니다."
           redirect_to edit_user_registration_path
         else
           flash[:error] = "알수없는 이유로 #{sns_provider} 계정이 저장되지 못했습니다."
           redirect_to ""
         end
       else
         flash[:warning] = "#{sns_provider} 계정은 이미 연결되었습니다."
         redirect_to ""
       end

    else
      @identity = User.from_omniauth(auth)

      if @identity.changed?
        # 이메일을 제공해주는 SNS일경우
        if @identity.email.present?
          flash[:success] = "#{sns_provider} 계정으로 회원가입이 완료되었습니다."
          redirect_to root_path

          # In case user's email was not confirmed
          if @identity.confirmed_at.blank?
            flash[:error] = "#{sns_provider} 계정의 이메일 확인이 실패했습니다. 이 오류는 관리자에게 문의해주셔야합니다."
            redirect_to root_path
          end
        else
        # 트위터같은 이메일 비제공 SNS 일경우, 따로 이메일 추가입력을 하도록 한다.
          session["devise.omniauth_data"] = User.build_twitter_auth_cookie_hash(request.env["omniauth.auth"])
          flash[:error] = "#{sns_provider}는 이메일정보를 제공하지 않으므로 윙스타에서 새로 인증을 하셔야합니다."
          render "users/omniauth_callbacks/add_email"
        end
      end
    end



  end




  def failure
    #handle you logic here..
    #and delegate to super.
    super
  end

  def twitter

  end

  def linkedin

  end


  alias_method :facebook, :all
  alias_method :twitter, :all
  alias_method :linkedin, :all
  alias_method :github, :all
  alias_method :passthru, :all
  alias_method :google_oauth2, :all


  # 로그인후 유저 프로필 페이지로 바로이동
  # def sign_in_and_redirect(resource_or_scope, *args)
  #   options  = args.extract_options!
  #   scope    = Devise::Mapping.find_scope!(resource_or_scope)
  #   resource = args.last || resource_or_scope
  #   sign_in(scope, resource, options)
  #   redirect_to edit_user_registration_path
  # end

  ###########################################################################################
  #  https://github.com/hacken-in/website/blob/master/app/controllers/callbacks_controller.rb
  ###########################################################################################
  # def all
  #
  #   # If there is no token, but we are currently logged in
  #   if current_user
  #     @auth = Authorization.create_authorization(request.env["omniauth.auth"], current_user)
  #     if @auth.persisted?
  #       redirect_to edit_user_registration_path, notice: t('registrations.oauth.added', provider: @auth.provider.humanize)
  #     else
  #       redirect_to edit_user_registration_path, flash: { error: t('registrations.oauth.in_use', provider: @auth.provider.humanize, uid: @auth.uid) }
  #     end
  #   else
  #     user = User.from_omniauth(request.env["omniauth.auth"])
  #
  #     if user.persisted?
  #       flash.notice = "Eingeloggt mit #{request.env["omniauth.auth"]["provider"].capitalize}"
  #       sign_in_and_redirect user
  #     else
  #       # Merge in the temp token manually, since it's not in the attributes
  #       session["devise.user_attributes"] = user.attributes.merge({ auth_temp_token: user.auth_temp_token })
  #       redirect_to new_user_registration_url
  #     end
  #   end
  # end

  # def facebook
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #
  #   logger.debug " * omniauth : #{request.env['omniauth.auth']} "
  #   @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
  #
  #   if @user.persisted?
  #     flash[:success] = "페이스북 계정으로 로그인했습니다."
  #     # set_flash_message(:success, :success, :kind => "Facebook") if is_navigational_format?
  #     sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

end