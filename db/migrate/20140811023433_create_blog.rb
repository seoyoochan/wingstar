class CreateBlog < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :url
      t.string :title
      t.references :user, index: true
      t.timestamps
    end
    add_index :blogs, :url, unique: true
  end
end
