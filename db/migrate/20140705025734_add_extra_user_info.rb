class AddExtraUserInfo < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :agreement, :boolean, default: true
    add_column :users, :date_of_birth, :date
    add_column :users, :locale, :string, default: 'en'
    add_column :users, :gender, :string, default: 'male'
    add_column :users, :name_format, :boolean, default: true
    add_column :users, :website, :string
    add_column :users, :name, :string
    add_column :users, :profile_image, :binary, :limit => 20.megabyte
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
    remove_column :users, :name
    remove_column :profile_image, :binary
  end
end
