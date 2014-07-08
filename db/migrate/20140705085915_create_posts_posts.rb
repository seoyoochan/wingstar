class CreatePostsPosts < ActiveRecord::Migration
  def change
    create_table :posts_posts do |t|

      t.timestamps
    end
  end
end
