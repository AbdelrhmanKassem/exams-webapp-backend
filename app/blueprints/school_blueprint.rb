class SchoolBlueprint < Blueprinter::Base
  identifier :id
  fields :name
  association :district, blueprint: DistrictBlueprint

  view :index do
    excludes :district
    field :district_name do |school|
      school.district.name
    end
    field :student_count do |school|
      school.students.count
    end
    field :governorate do |school|
      school.district.governorate
    end
  end
end
