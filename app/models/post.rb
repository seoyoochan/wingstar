class Post < ActiveRecord::Base
  resourcify
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
end
