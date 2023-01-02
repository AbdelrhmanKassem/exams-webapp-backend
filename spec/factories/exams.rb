# == Schema Information
#
# Table name: exams
#
#  id          :bigint           not null, primary key
#  examiner_id :bigint           not null
#  start_time  :datetime         not null
#  end_time    :datetime         not null
#  max_grade   :decimal(, )      not null
#  questions   :text             not null
#  answers     :text             not null
#
FactoryBot.define do
  factory :exam do
    user
    branch
    start_time { Faker::Time.between(from: DateTime.now + 6.hours, to: DateTime.now + 12.hours) }
    end_time { Faker::Time.between(from: DateTime.now + 14.hours, to: DateTime.now + 15.hours) }
    max_grade { Faker::Number.between(from: 10, to: 100) }
    questions { 'Questions Encrypted' }
    answers { 'Answers Encrypted' }
  end
end
