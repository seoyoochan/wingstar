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
    add_column :users, :description, :text
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_index  :users, :username, unique: true
    add_column :users, :job, :string
    add_column :users, :profile_image, :string
    add_column :users, :facebook_account_url, :string
    add_column :users, :twitter_account_url, :string
    add_column :users, :linkedin_account_url, :string
    add_column :users, :github_account_url, :string
    add_column :users, :googleplus_account_url, :string
    add_column :users, :phone, :string
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
    remove_column :users, :description
    remove_column :users, :name
    remove_column :users, :username
    remove_column :users, :job
    remove_column :users, :profile_image
    remove_column :users, :facebook_account_url
    remove_column :users, :twitter_account_url
    remove_column :users, :linkedin_account_url
    remove_column :users, :github_account_url
    remove_column :users, :googleplus_account_url
    remove_column :users, :phone
  end
end
