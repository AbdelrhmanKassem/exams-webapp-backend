FactoryBot.define do
  factory :student do
    username { Faker::Internet.unique.username(specifier: 3..30) }
    full_name { Faker::Alphanumeric.alpha(number: rand(5..24)) }
    email { Faker::Internet.unique.safe_email }
    branch { 'maths' }
    school
  end
end
