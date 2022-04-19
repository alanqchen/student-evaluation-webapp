class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :institution, null: false
      t.string :comments, null: false

      t.timestamps
    end
    add_index :requests, :email, unique: true
  end
end
