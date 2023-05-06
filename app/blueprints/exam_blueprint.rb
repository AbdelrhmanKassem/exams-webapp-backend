class ExamBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :start_time, :end_time, :max_grade, :branches
  association :examiner, blueprint: UserBlueprint
  association :branches, blueprint: BranchBlueprint

  view :trusted do
    field :questions
    field :answers
  end

  view :index do
    excludes :examiner
    field :examiner_name do |exam|
      exam.examiner.full_name
    end
  end
end
