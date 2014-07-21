class User < ActiveRecord::Base
  rolify

  include Authority::UserAbilities
  include ApplicationHelper

  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:facebook]

  after_create :set_default_role, if: Proc.new { User.count >= 1 }

  has_many :posts, dependent: :destroy
  has_many :identities, dependent: :destroy

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  validates_presence_of :name
  # validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update


  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: { :case_sensitive => false, :allow_blank => false }, format: { :with => Devise.email_regexp }, :if => :email_changed?
  validates :password, presence: { length: { within: Devise.password_length } }, :on => :create
  validates :password, presence: true, :on => :update, :unless => lambda { |user| user.password.blank? }

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
            name: auth.info.name || auth.extra.nickname ||  auth.uid,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    user

  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def self.find_for_facebook_oauth(auth)
    user = where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end

    # 이 때는 이상하게도 after_create 콜백이 호출되지 않아서 아래와 같은 조치를 했다.
    user.add_role :user if user.roles.empty?
    user   # 최종 반환값은 user 객체이어야 한다.
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private
  def set_default_role
    add_role :user
  end
end
