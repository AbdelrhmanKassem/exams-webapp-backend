class AddBranchToStudnet < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE student_branch AS ENUM ('general', 'maths', 'science', 'literature');
    SQL
    add_column :students, :branch, :student_branch
  end

  def down
    remove_column :students, :branch
    execute <<-SQL
      DROP TYPE student_branch;
    SQL
  end
end
