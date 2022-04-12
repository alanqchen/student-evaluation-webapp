class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.boolean :active, null: false

      t.timestamps
    end
  end
end
