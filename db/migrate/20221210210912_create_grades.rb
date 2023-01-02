class CreateGrades < ActiveRecord::Migration[7.0]
  def change
    create_table :grades, id: false do |t|
      t.references :student_seat_number, references: :students, null: false
      t.references :exam, null: false, foreign_key: true
      t.primary_keys [:student_seat_number_id, :exam_id]
      t.decimal :mark, null: false
    end
    rename_column :grades, :student_seat_number_id, :student_seat_number
    add_foreign_key :grades, :students, column: 'student_seat_number', primary_key: 'seat_number'
  end
end
