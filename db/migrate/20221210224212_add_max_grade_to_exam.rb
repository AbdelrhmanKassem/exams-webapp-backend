class AddMaxGradeToExam < ActiveRecord::Migration[7.0]
  def change
    add_column :exams, :max_grade, :decimal
  end
end
