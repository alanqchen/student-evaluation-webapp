# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_04_12_050545) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses_users", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "user_id", null: false
    t.index ["course_id", "user_id"], name: "index_courses_users", unique: true
  end

  create_table "evaluations", force: :cascade do |t|
    t.bigint "from_user_id", null: false
    t.bigint "to_user_id", null: false
    t.bigint "project_id", null: false
    t.integer "score", null: false
    t.string "comment", null: false
    t.boolean "completed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id", "to_user_id", "project_id"], name: "index_evaluations", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_projects_on_course_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_teams_on_course_id"
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.index ["team_id", "user_id"], name: "index_teams_users", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "instructor", null: false
    t.boolean "admin", null: false
    t.boolean "approver", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "courses_users", "courses"
  add_foreign_key "courses_users", "users"
  add_foreign_key "evaluations", "projects"
  add_foreign_key "evaluations", "users", column: "from_user_id"
  add_foreign_key "evaluations", "users", column: "to_user_id"
  add_foreign_key "projects", "courses"
  add_foreign_key "teams", "courses"
  add_foreign_key "teams_users", "teams"
  add_foreign_key "teams_users", "users"
end
