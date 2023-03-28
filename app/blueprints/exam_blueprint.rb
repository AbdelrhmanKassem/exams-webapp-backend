class ExamBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :start_time, :end_time, :max_grade, :branches
  association :examiner, blueprint: UserBlueprint
  association :branches, blueprint: BranchBlueprint

  view :trusted do
    field :questions
    field :answers
  end
end
