# == Schema Information
#
# Table name: exams
#
#  id          :bigint           not null, primary key
#  examiner_id :bigint           not null
#  questions   :json
#  answers     :text
#  start_time  :datetime
#  max_grade   :decimal(, )
#
FactoryBot.define do
  factory :exam do
    user
    exam_branches
    questions { {} }
    answers { '' }
  end
end
