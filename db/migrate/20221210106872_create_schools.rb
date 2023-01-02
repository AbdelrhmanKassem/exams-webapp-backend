class CreateSchools < ActiveRecord::Migration[7.0]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.references :district, null: false, foreign_key: true
    end
  end
end
