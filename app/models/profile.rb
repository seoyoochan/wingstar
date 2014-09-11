class Profile < ActiveRecord::Base
  resourcify
  include ApplicationHelper

  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  has_many :attachments, as: :attachable
  has_many :views, as: :viewable
  accepts_nested_attributes_for :attachments, allow_destroy: true

end
