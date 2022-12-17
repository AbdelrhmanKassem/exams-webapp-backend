FactoryBot.define do
  factory :exam do
    user
    branches { ['maths'] }
    questions { {} } 
    answers { '' }
  end
end
