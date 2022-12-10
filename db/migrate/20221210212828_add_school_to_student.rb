class AddSchoolToStudent < ActiveRecord::Migration[7.0]
  def change
    add_reference :students, :school, null: false, foreign_key: true, index: true
  end
end
