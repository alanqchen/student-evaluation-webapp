class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :instructor, null: false
      t.boolean :admin, null: false
      t.boolean :approver, null: false

      t.timestamps
    end
  end
end
