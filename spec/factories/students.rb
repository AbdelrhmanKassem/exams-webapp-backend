FactoryBot.define do
  factory :student do
    username { Faker::Internet.unique.username(specifier: 3..30) }
    first_name { Faker::Alphanumeric.alpha(number: rand(2..24)) }
    last_name { Faker::Alphanumeric.alpha(number: rand(2..24)) }
    email { Faker::Internet.unique.safe_email }
    password { 'Test@123123' }
    password_confirmation { 'Test@123123' }
  end
end
