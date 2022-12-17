class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :email, :role, :username, :first_name, :last_name
end
