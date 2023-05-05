class DistrictBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :governorate

  view :index do
    field :school_count do |district|
      district.schools.count
    end
  end
end
