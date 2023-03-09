# == Schema Information
#
# Table name: branches
#
#  id   :bigint           not null, primary key
#  name :string           not null
#
FactoryBot.define do
  factory :branch do
    to_create do |instance|
      instance.attributes = Branch.find_or_create_by(name: Rails.application.config.default_branches.sample).attributes
      instance.reload
    end
    name { Rails.application.config.default_branches.sample }
  end
end
