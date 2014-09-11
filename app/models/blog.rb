class Blog < ActiveRecord::Base
  resourcify
  include ApplicationHelper

  belongs_to :user
  has_many :posts

  validates :title, presence: true
  # validates :url, presence: true
  validates :url, uniqueness: { :case_sensitive => false, :allow_blank => false }

end