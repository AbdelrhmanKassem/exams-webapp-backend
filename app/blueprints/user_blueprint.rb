class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :email, :full_name
  association :role, blueprint: RoleBlueprint

  view :index do
    excludes :role
    field :role_name do |user|
      user.role.name
    end
  end
end
