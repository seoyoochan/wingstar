class Post < ActiveRecord::Base
  include VotesHelper

  resourcify
  acts_as_ordered_taggable
  acts_as_ordered_taggable_on :tags
  acts_as_voteable
  acts_as_commentable

  belongs_to :user
  belongs_to :blog
  has_many :attachments, as: :attachable, dependent:  :destroy
  has_many :views, as: :viewable, dependent:  :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true

  acts_as_url :title

  validates :title, presence: false
  validates :content, presence: true

  def to_param
    "#{id}/#{Sanitize.clean(title.delete('.~!@#$%^&*()_+{}|":?><`[]\/,-=').gsub(/[']/, '')).gsub(/\s+/, '-')}" unless title.nil?
  end

end
