FactoryBot.define do
  factory :grade do
    student
    exam
    mark { "9.99" }
  end
end
