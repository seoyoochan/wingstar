class CreateHighschools < ActiveRecord::Migration
  def change
    create_table :highschools do |t|
      t.string :school
      t.date :start
      t.date :end
      t.boolean :graduated
      t.text :description
      t.references :user, index: true

      t.timestamps
    end
  end
end
