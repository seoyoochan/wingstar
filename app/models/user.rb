class User < ActiveRecord::Base
  rolify
  after_create :set_default_roles, if: Proc.new { User.count > 1 }

  include ApplicationHelper


  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  has_many :posts, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: { :case_sensitive => false, :allow_blank => false }, format: { :with => Devise.email_regexp }, :if => :email_changed?
  validates :password, presence: { length: { within: Devise.password_length } }, :on => :create
  validates :password, presence: true, :on => :update, :unless => lambda { |user| user.password.blank? }


  private
  def set_default_roles
    add_role :user
  end

  protected
  def confirmation_required?
    true
  end
end
