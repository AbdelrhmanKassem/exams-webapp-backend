class AddNameToExam < ActiveRecord::Migration[7.0]
  def change
    add_column :exams, :name, :string
  end
end
