class StudentBlueprint < Blueprinter::Base
  identifier :seat_number

  fields :full_name, :email

  association :school, blueprint: SchoolBlueprint
  association :branch, blueprint: BranchBlueprint
end
