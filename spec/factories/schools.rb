# == Schema Information
#
# Table name: schools
#
#  id          :bigint           not null, primary key
#  name        :string
#  governorate :string
#  district    :string
#
FactoryBot.define do
  factory :school do
    name { "MyString" }
    governorate { "MyString" }
    district { "MyString" }
  end
end
