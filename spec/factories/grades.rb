# == Schema Information
#
# Table name: grades
#
#  student_seat_number :bigint           not null, primary key
#  exam_id             :bigint           not null, primary key
#  mark                :decimal(, )
#
FactoryBot.define do
  factory :grade do
    student
    exam
    mark { "9.99" }
  end
end
