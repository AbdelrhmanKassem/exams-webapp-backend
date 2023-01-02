# == Schema Information
#
# Table name: students
#
#  seat_number :bigint           not null, primary key
#  school_id   :bigint           not null
#  branch_id   :bigint           not null
#  full_name   :string           not null
#  email       :string
#
FactoryBot.define do
  factory :student do
    full_name { Faker::Alphanumeric.alpha(number: rand(5..24)) }
    email { Faker::Internet.unique.safe_email }
    branch
    seat_number { Faker::Number.number(digits: 6) }
    school
  end
end
