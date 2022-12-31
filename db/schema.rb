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

ActiveRecord::Schema[7.0].define(version: 2022_12_31_191048) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "student_branch", ["math", "science", "literature"]

  create_table "exam_branches", primary_key: ["exam_id", "branch"], force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.enum "branch", null: false, enum_type: "student_branch"
    t.index ["exam_id"], name: "index_exam_branches_on_exam_id"
  end

  create_table "exams", force: :cascade do |t|
    t.bigint "examiner_id", null: false
    t.json "questions"
    t.text "answers"
    t.datetime "start_time"
    t.decimal "max_grade"
    t.index ["examiner_id"], name: "index_exams_on_examiner_id"
  end

  create_table "grades", primary_key: ["student_seat_number", "exam_id"], force: :cascade do |t|
    t.bigint "student_seat_number", null: false
    t.bigint "exam_id", null: false
    t.decimal "mark"
    t.index ["exam_id"], name: "index_grades_on_exam_id"
    t.index ["student_seat_number"], name: "index_grades_on_student_seat_number"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "governorate"
    t.string "district"
  end

  create_table "students", primary_key: "seat_number", force: :cascade do |t|
    t.string "username"
    t.string "full_name"
    t.string "email"
    t.enum "branch", enum_type: "student_branch"
    t.bigint "school_id", null: false
    t.index ["school_id"], name: "index_students_on_school_id"
    t.index ["seat_number"], name: "index_students_on_seat_number"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
  end

  add_foreign_key "exam_branches", "exams"
  add_foreign_key "exams", "users", column: "examiner_id"
  add_foreign_key "grades", "exams"
  add_foreign_key "grades", "students", column: "student_seat_number", primary_key: "seat_number"
  add_foreign_key "students", "schools"
end
