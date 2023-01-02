class SchoolBlueprint < Blueprinter::Base
  identifier :id
  fields :name
  association :district, blueprint: DistrictBlueprint

  view :index do
    excludes :district
  end
end
