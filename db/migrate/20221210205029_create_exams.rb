class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.references :examiner, null: false, foreign_key: { to_table: :users }
      t.json :questions
      t.text :answers
      t.datetime :start_time
    end
  end
end
