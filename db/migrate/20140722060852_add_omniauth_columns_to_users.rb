class AddOmniauthColumnsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :provider, :string
    add_column :users, :uid, :bigint
  end
  def down
    add_column :users, :provider
    add_column :users, :uid
  end
end
