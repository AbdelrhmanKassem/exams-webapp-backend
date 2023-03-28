# == Schema Information
#
# Table name: cheat_cases
#
#  student_seat_number :bigint           not null, primary key
#  exam_id             :bigint           not null, primary key
#  proctor_id          :bigint           not null
#  notes               :text
#
FactoryBot.define do
  factory :cheat_case do
    student
    exam
    association :proctor, factory: :proctor_user
    notes { Faker::Lorem.paragraph(sentence_count: rand(1..5)) }
  end
end
