class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students, id: false do |t|
      t.string :username
      t.string :full_name
      t.string :email
      t.bigint :seat_number, primary_key: true
    end
  end
end
