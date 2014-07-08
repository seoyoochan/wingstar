class AddExtraUserInfo < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :agreement, :boolean, default: false
    add_column :users, :date_of_birth, :date
    add_column :users, :locale, :string, default: 'en'
    add_column :users, :gender, :string
  end

  def down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :agreement
    remove_column :users, :date_of_birth
    remove_column :users, :locale
    remove_column :users, :gender
  end
end
