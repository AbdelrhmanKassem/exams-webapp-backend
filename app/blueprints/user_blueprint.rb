class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :email, :first_name, :last_name
  association :role, blueprint: RoleBlueprint

end
