class RoleBlueprint < Blueprinter::Base
  identifier :id

  fields :name

  view :index do
    field :user_count do |role|
      role.users.count
    end
  end
end
