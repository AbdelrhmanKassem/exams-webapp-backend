class BranchBlueprint < Blueprinter::Base
  identifier :id

  fields :name

  view :index do
    field :student_count do |branch|
      branch.students.count
    end
    field :exam_count do |branch|
      branch.exams.count
    end
  end
end
