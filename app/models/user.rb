class User < ActiveRecord::Base
  include ApplicationHelper

  rolify
  after_create :set_default_roles, if: Proc.new { User.count > 1 }

  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, :omniauthable

  has_many :posts, dependent: :destroy
  has_many :authorizations, dependent: :destroy



  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, :allow_blank => true, :on => create
  validates :email, uniqueness: { :case_sensitive => false, :allow_blank => false }, format: { :with => Devise.email_regexp }, :if => :email_changed?
  validates :password, presence: { length: { within: Devise.password_length } }, :on => :create
  validates :password, presence: true, :on => :update, :unless => lambda { |user| user.password.blank? }
  validates :date_of_birth, presence: false
  validates :locale, presence: true
  validates :gender, presence: true
  validates :agreement, presence: true

  def self.fb_locales_available(fb_user_locale)
    locales = {"en_US" => "en", "ko_KR" => "ko"}
    if locales.include?(fb_user_locale)
      locales[fb_user_locale].to_s
    else
      "en"
    end
  end

  def self.tw_locales_available(tw_user_locale)
    if I18n.available_locales.include?(tw_user_locale)
      tw_user_locale
    else
      "en"
    end
  end

  def self.linkedin_locales_available(linkedin_user_locale)
    locales = {"us" => "en", "kr" => "ko"}
    if locales.include?(linkedin_user_locale)
      locales[linkedin_user_locale].to_s
    else
      "en"
    end
  end


  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"],without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end


  def self.from_omniauth(auth, current_user = nil)
    logger.debug " * auth : #{auth} "
    # 해당 SNS의 계정이 존재하는지 Authorization 데이터베이스에서 조회
    identity = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token).first_or_initialize
    logger.debug " * authorizaiton : #{identity} "
    # 해당 SNS의 계정 이메일도 User 데이터베이스에서 조회
    user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user

    # 이미 로그인한 사용자(시나리오01: SNS 최초인증 / SNS 이미 인증)
    if current_user

      # 로그인 사용자의 SNS 최초인증 (identity.user_id는 공백 상태이므로)
      if identity.user_id != current_user.id
        # 인증 표시
        identity.user_id = current_user.id
        # 현재 유저의 DB에 가져온 SNS의 정보를 입력함
        sns_crawling(auth.provider)
      else
      # 로그인 사용자가 SNS 이미 인증한것을 클릭할때
        current_user
      end

    else
    # 로그인하지 않은 상태(시나리오02: 이미 인증한 사용자의 SNS를 통한 로그인 / 비인증된 최초의 SNS로그인(사실상 SNS를 통한 회원가입))

      # 이미 인증한 사용자의 SNS를 통한 로그인
      if identity.user_id.present?
        # 아이디 식별후 리턴
        if identity.user_id == user.id
          user
        end
      else
      # 비인증된 최초의 SNS로그인(사실상 SNS를 통한 회원가입)과 동시에 이메일을 등록한적이 없어야 가입진행
        if user.blank?
          if provide_email?
            signup_by_facebook
            signup_by_google_oauth2
            signup_by_github
            signup_by_linkedin
          else
            signup_by_twitter
          end
        end
      end
    end

  end

  def self.generate_default_signup_info
    user = User.new
    user.password = Devise.friendly_token[0,20]
    user.agreement = 1
  end

  def self.signup_by_facebook
    if auth.provider == "facebook"
      generate_default_signup_info
      user.confirmed_at = Time.now
      user.name = auth.info.name if user.name.blank?
      user.email = auth.info.email if user.email.blank?
      user.username = auth.info.nickname if user.username.blank?
      user.first_name = auth.info.first_name if user.first_name.blank?
      user.last_name = auth.info.last_name if user.last_name.blank?
      user.locale = fb_locales_available(auth.extra.raw_info.locale) if user.locale.blank?
      user.gender = auth.extra.raw_info.gender if user.gender.blank?
      user.location = auth.info.location if user.location.blank?
      user.facebook_account_url = auth.info.urls.Facebook if user.facebook_account_url.blank?
      user.profile_image = auth.info.image if user.profile_image.blank?
      user.save
      identity.user_id = user.id
      user
    end
  end

  def self.signup_by_google_oauth2
    generate_default_signup_info
    user.confirmed_at = Time.now
    user.name = auth.info.name if user.name.blank?
    user.email = auth.info.email if user.email.blank?
    user.first_name = auth.info.first_name if user.first_name.blank?
    user.last_name = auth.info.last_name if user.last_name.blank?
    user.profile_image = auth.info.image if user.profile_image.blank?
    user.googleplus_account_url = auth.extra.raw_info.profile if user.googleplus_account_url
    user.gender = auth.extra.raw_info.gender if user.gender
    user.date_of_birth = auth.extra.raw_info.birthday if user.date_of_birth
    user.locale = auth.extra.raw_info.locale if user.locale
    # user.website = auth.extra.raw_info.hd if user.website
    user.save
    identity.user_id = user.id
    user
  end

  def self.signup_by_github

  end

  def self.signup_by_twitter
    generate_default_signup_info
    user.name = auth.info.name if user.name.blank?
    user.username = auth.info.nickname if user.username.blank?
    user.location = auth.info.location if user.location.blank?
    user.profile_image = auth.info.image if user.profile_image.blank?
    user.about = auth.info.description if user.about.blank?
    user.website = auth.info.urls.Website if user.website.blank?
    user.twitter_account_url = auth.info.urls.Twitter if user.twitter_account_url.blank?
    user.locale = tw_locales_available(auth.extra.lang) if user.locale.blank?
    user.email = nil
    # Note that user MUST NOT be saved here
    user
  end

  def self.signup_by_linkedin
    generate_default_signup_info
    user.confirmed_at = Time.now
    user.email = auth.info.email if user.email.blank?
    user.name = auth.info.name if user.name.blank?
    user.first_name = auth.info.first_name if user.first_name.blank?
    user.last_name = auth.info.last_name if user.last_name.blank?
    user.username = auth.info.nickname if user.username.blank?
    user.location = auth.info.location if user.location.blank?
    user.profile_image = auth.info.image if user.profile_image.blank?
    user.about = auth.info.description if user.about.blank?
    user.linkedin_account_url = auth.info.urls.public_profile if user.linkedin_account_url.blank?
    user.locale = linkedin_locales_available(auth.extra.raw_info.location.country.code) if user.locale.blank?
    user.save
    user
  end

  def self.provide_email?
    # 이메일 제공하지 않는 SNS 블랙리스트
    if auth.provider == "twitter"
      false
    else
      true
    end
  end

  def self.sns_crawling(provider)
    if provider == "facebook"
      current_user.name = auth.info.name if current_user.name.blank?
      current_user.email = auth.info.email if current_user.email.blank?
      current_user.username = auth.info.nickname if current_user.username.blank?
      current_user.first_name = auth.info.first_name if current_user.first_name.blank?
      current_user.last_name = auth.info.last_name if current_user.last_name.blank?
      current_user.locale = fb_locales_available(auth.extra.raw_info.locale) if current_user.locale.blank?
      current_user.gender = auth.extra.raw_info.gender if current_user.gender.blank?
      current_user.location = auth.info.location if current_user.location.blank?
      current_user.facebook_account_url = auth.info.urls.Facebook if current_user.facebook_account_url.blank?
      current_user.profile_image = auth.info.image if current_user.profile_image.blank?
      # current_user.save!
      current_user
    end

    if provider == "twitter"
      current_user.name = auth.info.name if current_user.name.blank?
      current_user.username = auth.info.nickname if current_user.username.blank?
      current_user.location = auth.info.location if current_user.location.blank?
      current_user.profile_image = auth.info.image if current_user.profile_image.blank?
      current_user.about = auth.info.description if current_user.about.blank?
      current_user.website = auth.info.urls.Website if current_user.website.blank?
      current_user.twitter_account_url = auth.info.urls.Twitter if current_user.twitter_account_url.blank?
      current_user.locale = tw_locales_available(auth.extra.lang) if current_user.locale.blank?
      # current_user.save!
      current_user
    end

    if provider == "google_oauth2"
      current_user.name = auth.info.name if current_user.name.blank?
      current_user.email = auth.info.email if current_user.email.blank?
      current_user.first_name = auth.info.first_name if current_user.first_name.blank?
      current_user.last_name = auth.info.last_name if current_user.last_name.blank?
      current_user.profile_image = auth.info.image if current_user.profile_image.blank?
      current_user.googleplus_account_url = auth.extra.raw_info.profile if current_user.googleplus_account_url
      current_user.gender = auth.extra.raw_info.gender if current_user.gender
      current_user.date_of_birth = auth.extra.raw_info.birthday if current_user.date_of_birth
      current_user.locale = auth.extra.raw_info.locale if current_user.locale
      # current_user.website = auth.extra.raw_info.hd if current_user.website
      # current_user.save!
      current_user
    end

    if provider == "github"

    end
  end

  def self.build_twitter_auth_cookie_hash(data)
    {
        :provider => data.provider,
        :uid => data.uid.to_i,
        :credentials => {
            :token => data.credentials.token
        },
        :secret => data.credentials.secret,
        :name => data.info.name,
        :username => data.info.nickname,
        :location => data.info.location,
        :profile_image => data.info.image,
        :about => data.info.description,
        :website => data.info.urls.Website,
        :twitter_account_url => data.info.urls.Twitter,
        :locale => tw_locales_available(data.extra.lang)
    }
  end

  def add_email_identity(data)
    identity = Authorization.where(:provider => data.provider, :uid => data.uid.to_s, :token => data.credentials.token).first_or_initialize

    generate_default_signup_info
    user.confirmed_at = Time.now
    user.name = data.name if user.name.blank?
    user.username = data.username if user.username.blank?
    user.location = data.location if user.location.blank?
    user.profile_image = data.profile_image if user.profile_image.blank?
    user.about = data.about if user.about.blank?
    user.website = data.website if user.website.blank?
    user.twitter_account_url = data.twitter_account_url if user.twitter_account_url.blank?
    user.locale = data.locale if user.locale.blank?
    user.email = data.email
    user.save
    identity.user_id = user.id
    user
  end



  # def self.from_omniauth(auth, current_user)
  #   authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
  #
  #   if authorization.user.blank?
  #     user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
  #
  #     if user.blank?
  #       user = User.new
  #       user.password = Devise.friendly_token[0,10]
  #       user.name = auth.info.name
  #       user.email = auth.info.email
  #       auth.provider == "twitter" ?  user.save(:validate => false) :  user.save
  #     end
  #
  #     authorization.username = auth.info.nickname
  #     authorization.user_id = user.id
  #     authorization.save
  #   end
  #
  #   authorization.user
  # end



  #
  # def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
  #
  #   basic_data = access_token.extra.raw_info
  #   if user = User.where(:email => basic_data.email).first
  #     user
  #   else
  #
  #     User.create!(
  #         :provider => access_token.provider,
  #         :uid => access_token.uid,
  #         :profile_image => access_token.info.image,
  #         :email => basic_data.email,
  #         :password => Devise.friendly_token[0,20],
  #         :first_name => basic_data.first_name,
  #         :last_name => basic_data.last_name,
  #         :name => basic_data.name,
  #         :gender => basic_data.gender,
  #         :locale => fb_locales_available(basic_data.locale),
  #         :fb_profile_link => basic_data.link#,
  #         #:date_of_birth => Date.strptime(basic_data.birthday,'%m/%d/%Y')
  #     )
  #   end
  # end
  #
  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if basic_data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = basic_data["email"]
  #     end
  #   end
  # end


  # 효성님 튜토리얼
  # def self.find_for_facebook_oauth(auth)
  #   user = where(auth.slice(:provider, :uid)).first_or_create do |user|
  #     user.provider = auth.provider
  #     user.uid = auth.uid
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0,20]
  #     user.name = auth.info.name   # assuming the user model has a name
  #     user.image = auth.info.image # assuming the user model has an image
  #   end
  #
  #   # 이 때는 이상하게도 after_create 콜백이 호출되지 않아서 아래와 같은 조치를 했다.
  #   user.add_role :user if user.roles.empty?
  #   user   # 최종 반환값은 user 객체이어야 한다.
  # end
  #
  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = data["email"] if user.email.blank?
  #       user.first_name = data["first_name"] if user.first_name.blank?
  #       user.last_name = data["last_name"] if user.last_name.blank?
  #       user.gender = data["gender"] if user.gender.blank?
  #       user.locale = data["locale"] if user.locale.blank?
  #     end
  #   end
  # end

  private
  def set_default_roles
    add_role :user
  end

  protected
  def confirmation_required?
    true
  end
end
