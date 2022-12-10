FactoryBot.define do
  factory :exam do
    admin
    branches { ['maths'] }
    questions { {} } 
    answers { '' }
  end
end
