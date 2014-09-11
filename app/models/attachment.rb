class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  mount_uploader :file_name, AttachmentUploader, :mount_on => :file_name

end
