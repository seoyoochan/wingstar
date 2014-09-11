class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file_name
      t.integer :attachable_id
      t.string  :attachable_type
      # t.references :attachable, polymolphic: true
      t.timestamps
    end
  end
end
