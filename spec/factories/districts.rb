# == Schema Information
#
# Table name: districts
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  governorate :string           not null
#
FactoryBot.define do
  factory :district do
    name { Faker::Address.unique.city }
    governorate { Faker::Nation.unique.capital_city }
  end
end
