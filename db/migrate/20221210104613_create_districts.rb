class CreateDistricts < ActiveRecord::Migration[7.0]
  def change
    create_table :districts do |t|
      t.string :name, null: false, unique: true
      t.string :governorate, null: false, index: true, unique: true
    end
  end
end
