class SeatNumberChangeColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column(:students, :seat_number, 'bigint USING CAST(seat_number AS bigint)')
    add_index :students, :seat_number
  end
end
