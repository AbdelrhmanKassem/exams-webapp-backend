# == Schema Information
#
# Table name: students
#
#  username    :string
#  full_name   :string
#  email       :string
#  seat_number :bigint           not null, primary key
#  branch      :enum
#  school_id   :bigint           not null
#
FactoryBot.define do
  factory :student do
    username { Faker::Internet.unique.username(specifier: 3..30) }
    full_name { Faker::Alphanumeric.alpha(number: rand(5..24)) }
    email { Faker::Internet.unique.safe_email }
    branch { Student.branches.keys.sample.to_s }
    seat_number { Faker::Number.number(digits: 6)  }
    school
  end
end
