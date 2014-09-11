class AddSlugToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :url, :string, :unique => true
    add_index :posts, :url
  end
end
