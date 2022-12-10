class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :username
      t.string :full_name
      t.string :email
      t.string :seat_number
      t.timestamps
    end
  end
end
