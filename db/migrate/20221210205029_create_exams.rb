class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.references :examiner, null: false, foreign_key: { to_table: :admins }
      t.string :branches, array: true, default: []
      t.json :questions
      t.text :answers

      t.timestamps
    end
  end
end
