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
    name { Faker::Alphanumeric.alpha(number: rand(5..8)) }
    district
  end
end
