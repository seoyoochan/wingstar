class User < ActiveRecord::Base
  include ApplicationHelper
  rolify
  after_create :set_default_roles, if: Proc.new { User.count > 1 }

  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  has_many :posts, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: { :case_sensitive => false, :allow_blank => false }, format: { :with => Devise.email_regexp }, :if => :email_changed?
  validates :password, presence: { length: { within: Devise.password_length } }, :on => :create
  validates :password, presence: true, :on => :update, :unless => lambda { |user| user.password.blank? }
  validates :date_of_birth, presence: false
  validates :locale, presence: true
  validates :gender, presence: true
  validates :agreement, presence: true

  def self.fb_locales_available(fb_user_locale)
    @fb_locales = {"en_US" => "en", "ko_KR" => "ko"}
    if @fb_locales.include?(fb_user_locale)
      @fb_locales[fb_user_locale].to_s
    else
      "en"
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)

    basic_data = access_token.extra.raw_info
    if user = User.where(:email => basic_data.email).first
      user
    else

      User.create!(
          :provider => access_token.provider,
          :uid => access_token.uid,
          :profile_image => access_token.info.image,
          :email => basic_data.email,
          :password => Devise.friendly_token[0,20],
          :first_name => basic_data.first_name,
          :last_name => basic_data.last_name,
          :name => basic_data.name,
          :gender => basic_data.gender,
          :locale => fb_locales_available(basic_data.locale),
          :fb_profile_link => basic_data.link#,
          #:date_of_birth => Date.strptime(basic_data.birthday,'%m/%d/%Y')
      )
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if basic_data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = basic_data["email"]
      end
    end
  end


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
