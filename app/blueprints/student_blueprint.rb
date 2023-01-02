class StudentBlueprint < Blueprinter::Base
  identifier :id

  fields :full_name, :email, :seat_number

  association :school, blueprint: SchoolBlueprint
  association :branch, blueprint: BranchBlueprint
end
