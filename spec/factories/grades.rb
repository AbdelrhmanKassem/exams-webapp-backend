# == Schema Information
#
# Table name: grades
#
#  id         :bigint           not null, primary key
#  student_id :bigint           not null
#  exam_id    :bigint           not null
#  mark       :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :grade do
    student
    exam
    mark { "9.99" }
  end
end
