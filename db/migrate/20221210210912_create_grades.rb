class CreateGrades < ActiveRecord::Migration[7.0]
  def change
    create_table :grades do |t|
      t.references :student, null: false, foreign_key: true
      t.references :exam, null: false, foreign_key: true
      t.decimal :mark

      t.timestamps
    end
  end
end
