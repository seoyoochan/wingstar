class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :school
      t.date :start
      t.date :end
      t.boolean :graduated
      t.text :description
      t.string :concentrations_1
      t.string :concentrations_2
      t.string :concentrations_3
      t.boolean :attended_for
      t.references :user, index: true

      t.timestamps
    end
  end
end
