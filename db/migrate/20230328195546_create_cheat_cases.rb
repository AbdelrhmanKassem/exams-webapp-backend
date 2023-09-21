class CreateCheatCases < ActiveRecord::Migration[7.0]
  def change
    create_table :cheat_cases, id: false do |t|
      t.references :student_seat_number, references: :students, null: false
      t.references :exam, null: false, foreign_key: true, index: true, on_delete: :cascade
      t.primary_keys [:student_seat_number_id, :exam_id]
      t.references :proctor, null: false, foreign_key: { to_table: :users }, index: true, on_delete: :cascade
      t.text :notes
    end
    rename_column :cheat_cases, :student_seat_number_id, :student_seat_number
    add_foreign_key :cheat_cases, :students, column: 'student_seat_number', primary_key: 'seat_number', on_delete: :cascade
  end
end
