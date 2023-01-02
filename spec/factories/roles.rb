# == Schema Information
#
# Table name: roles
#
#  id   :bigint           not null, primary key
#  name :string           not null
#
FactoryBot.define do
  factory :role do
    to_create do |instance|
      instance.attributes = Role.find_or_create_by(name: Rails.application.config.default_roles.sample).attributes
      instance.instance_variable_set('@new_record', false)
    end
  end
end
