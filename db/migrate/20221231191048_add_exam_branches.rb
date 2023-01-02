class AddExamBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_branches, id: false do |t|
      t.references :exam, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.primary_keys [:exam_id, :branch_id]
    end
  end
end
