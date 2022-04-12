class CreateEvaluations < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluations do |t|
      t.integer :from_user_id, null: false
      t.integer :to_user_id, null: false
      t.integer :project_id, null: false
      t.integer :score, null: false
      t.string :comment, null: false
      t.boolean :completed, null: false

      t.timestamps
    end
    add_index :evaluations, [:from_user_id, :to_user_id, :project_id], unique: true, name: 'index_evaluations'
  end
end
