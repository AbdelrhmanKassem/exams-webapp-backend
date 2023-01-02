class SchoolBlueprint < Blueprinter::Base
  identifier :id
  fields :name
  association :district, blueprint: DistrictBlueprint
end
