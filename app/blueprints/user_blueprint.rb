class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :email, :role, :username
end
