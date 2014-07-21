class Post < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
end
