class CreateProfile < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :url
      t.string :cover
      t.references :user, index: true
    end
    add_index :profiles, :url, unique: true
  end
end
