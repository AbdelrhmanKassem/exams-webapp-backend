class CreateBranch < ActiveRecord::Migration[7.0]
  def change
    create_table :branches do |t|
      t.string :name, null: false, unique: true
    end
  end
end
