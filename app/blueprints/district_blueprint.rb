class DistrictBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :governorate

  view :index do
    field :school_count do |district|
      district.schools.count
    end
  end

  view :list do
    excludes :id, :name, :governorate
    field :value do |district|
      district.id
    end
    field :label do |district|
      district.name
    end
  end
end
