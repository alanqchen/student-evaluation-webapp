class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.belongs_to :course, index: true, foreign_key: true

      t.timestamps
    end
  end
end
