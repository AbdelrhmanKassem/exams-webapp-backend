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

ActiveRecord::Schema[7.0].define(version: 2023_05_05_173913) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "cheat_cases", primary_key: ["student_seat_number", "exam_id"], force: :cascade do |t|
    t.bigint "student_seat_number", null: false
    t.bigint "exam_id", null: false
    t.bigint "proctor_id", null: false
    t.text "notes"
    t.index ["exam_id"], name: "index_cheat_cases_on_exam_id"
    t.index ["proctor_id"], name: "index_cheat_cases_on_proctor_id"
    t.index ["student_seat_number"], name: "index_cheat_cases_on_student_seat_number"
  end

  create_table "districts", force: :cascade do |t|
    t.string "name", null: false
    t.string "governorate", null: false
    t.index ["governorate"], name: "index_districts_on_governorate"
  end

  create_table "exam_branches", primary_key: ["exam_id", "branch_id"], force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "branch_id", null: false
    t.index ["branch_id"], name: "index_exam_branches_on_branch_id"
    t.index ["exam_id"], name: "index_exam_branches_on_exam_id"
  end

  create_table "exams", force: :cascade do |t|
    t.bigint "examiner_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.decimal "max_grade", null: false
    t.text "questions", null: false
    t.text "answers", null: false
    t.string "name"
    t.index ["examiner_id"], name: "index_exams_on_examiner_id"
  end

  create_table "grades", primary_key: ["student_seat_number", "exam_id"], force: :cascade do |t|
    t.bigint "student_seat_number", null: false
    t.bigint "exam_id", null: false
    t.decimal "mark", null: false
    t.index ["exam_id"], name: "index_grades_on_exam_id"
    t.index ["student_seat_number"], name: "index_grades_on_student_seat_number"
  end

  create_table "password_reset_tokens", primary_key: "user_id", force: :cascade do |t|
    t.string "token_hash", null: false
    t.index ["token_hash"], name: "index_password_reset_tokens_on_token_hash"
    t.index ["user_id"], name: "index_password_reset_tokens_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "district_id", null: false
    t.index ["district_id"], name: "index_schools_on_district_id"
  end

  create_table "students", primary_key: "seat_number", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "branch_id", null: false
    t.string "full_name", null: false
    t.string "email"
    t.index ["branch_id"], name: "index_students_on_branch_id"
    t.index ["school_id"], name: "index_students_on_school_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.string "full_name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "cheat_cases", "exams"
  add_foreign_key "cheat_cases", "students", column: "student_seat_number", primary_key: "seat_number"
  add_foreign_key "cheat_cases", "users", column: "proctor_id"
  add_foreign_key "exam_branches", "branches"
  add_foreign_key "exam_branches", "exams"
  add_foreign_key "exams", "users", column: "examiner_id"
  add_foreign_key "grades", "exams"
  add_foreign_key "grades", "students", column: "student_seat_number", primary_key: "seat_number"
  add_foreign_key "password_reset_tokens", "users"
  add_foreign_key "schools", "districts"
  add_foreign_key "students", "branches"
  add_foreign_key "students", "schools"
  add_foreign_key "users", "roles"
end
