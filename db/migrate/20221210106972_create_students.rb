class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students, id: false do |t|
      t.bigint :seat_number, primary_key: true
      t.references :school, null: false, foreign_key: true, index: true
      t.references :branch, null: false, foreign_key: true
      t.string :full_name, null: false
      t.string :email
    end
  end
end
