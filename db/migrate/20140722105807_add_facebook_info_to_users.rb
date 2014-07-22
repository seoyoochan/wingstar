class AddFacebookInfoToUsers < ActiveRecord::Migration
  def up
    add_column :users, :fb_id, :bigint
    add_column :users, :about, :text
    add_column :users, :bio, :text
    add_column :users, :education, :binary
    add_column :users, :fb_profile_link, :string
    add_column :users, :location, :string
  end

  def down
    remove_column :users, :fb_id
    remove_column :users, :about
    remove_column :users, :bio
    remove_column :users, :education
    remove_column :users, :profile_link
    remove_column :users, :location
  end
end
