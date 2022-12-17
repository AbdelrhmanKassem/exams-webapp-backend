class StudentBlueprint < Blueprinter::Base
  identifier :id

  fields :username, :full_name, :email, :seat_number, :branch

  association :school, blueprint: SchoolBlueprint
end
