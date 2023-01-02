class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.references :role, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
    end
  end
end
