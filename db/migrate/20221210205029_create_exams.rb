class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.references :examiner, null: false, foreign_key: { to_table: :users }
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.decimal :max_grade, null: false
      t.text :questions, null: false
      t.text :answers, null: false
    end
  end
end
