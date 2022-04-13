class CreateEvaluations < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluations do |t|
      t.bigint :from_user_id, null: false
      t.bigint :to_user_id, null: false
      t.bigint :project_id, null: false
      t.integer :score, null: false
      t.string :comment, null: false
      t.boolean :completed, null: false

      t.timestamps
    end
    add_index :evaluations, [:from_user_id, :to_user_id, :project_id], unique: true, name: 'index_evaluations'
    add_foreign_key :evaluations, :users, column: :from_user_id, primary_key: "id"
    add_foreign_key :evaluations, :users, column: :to_user_id, primary_key: "id"
    add_foreign_key :evaluations, :projects, column: :project_id, primary_key: "id"
  end
end
