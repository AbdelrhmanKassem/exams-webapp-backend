class StudentBlueprint < Blueprinter::Base
  identifier :seat_number

  fields :full_name, :email

  association :school, blueprint: SchoolBlueprint
  association :branch, blueprint: BranchBlueprint

  view :index do
    excludes :school, :branch
    field :school_name do |student|
      student.school.name
    end
    field :branch_name do |student|
      student.branch.name
    end
  end
end
