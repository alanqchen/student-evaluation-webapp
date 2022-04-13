class CreateCoursesUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :courses, :users
    add_index :courses_users, [:course_id, :user_id], unique: true, name: 'index_courses_users'
    add_foreign_key :courses_users, :courses
    add_foreign_key :courses_users, :users
  end
end
