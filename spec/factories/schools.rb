# == Schema Information
#
# Table name: schools
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  district_id :bigint           not null
#
FactoryBot.define do
  factory :school do
    name { Faker::Educator.secondary_school }
    district
  end
end
