# == Schema Information
#
# Table name: exams
#
#  id          :bigint           not null, primary key
#  examiner_id :bigint           not null
#  branches    :string           default([]), is an Array
#  questions   :json
#  answers     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  max_grade   :decimal(, )
#
FactoryBot.define do
  factory :exam do
    user
    branches { ['maths'] }
    questions { {} } 
    answers { '' }
  end
end
