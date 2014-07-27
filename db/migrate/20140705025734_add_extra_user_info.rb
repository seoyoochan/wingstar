class AddExtraUserInfo < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :agreement, :boolean, default: true
    add_column :users, :date_of_birth, :date
    add_column :users, :locale, :string, default: 'en'
    add_column :users, :gender, :string
    add_column :users, :name_format, :string
    add_column :users, :website, :string
    add_column :users, :about, :text
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :profile_image, :string
    add_column :users, :location, :string
    # add_column :users, :remote_avatar_url, :string
    # add_column :users, :remote_image_url, :string
    add_column :users, :facebook_account_url, :string
    add_column :users, :twitter_account_url, :string
    add_column :users, :linkedin_account_url, :string
    add_column :users, :github_account_url, :string
    add_column :users, :googleplus_account_url, :string
    add_column :users, :phone, :string
    add_column :users, :industry, :string
  end

  def down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :agreement
    remove_column :users, :date_of_birth
    remove_column :users, :locale
    remove_column :users, :gender
    remove_column :users, :name_format
    remove_column :users, :website
    remove_column :users, :about
    remove_column :users, :name
    remove_column :users, :username
    remove_column :users, :profile_image
    remove_column :users, :location
    # remove_column :users, :remote_avatar_url
    # remove_column :users, :remote_image_url
    remove_column :users, :facebook_account_url
    remove_column :users, :twitter_account_url
    remove_column :users, :linkedin_account_url
    remove_column :users, :github_account_url
    remove_column :users, :googleplus_account_url
    remove_column :users, :phone
    remove_column :users, :industry
  end
end
