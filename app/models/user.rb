class User < ActiveRecord::Base
  include ApplicationHelper

  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable


  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: { :case_sensitive => false, :allow_blank => false }, format: { :with => Devise.email_regexp }, :if => :email_changed?
  validates :password, presence: { length: { within: Devise.password_length } }, :on => :create
  validates :password, presence: true, :on => :update, :unless => lambda { |user| user.password.blank? }

end
