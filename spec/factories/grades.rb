# == Schema Information
#
# Table name: grades
#
#  student_seat_number :bigint           not null, primary key
#  exam_id             :bigint           not null, primary key
#  mark                :decimal(, )      not null
#
FactoryBot.define do
  factory :grade do
    student
    exam
    max_grade { Faker::Number.decimal(l_digits: 2, r_digits: 2)  }
  end
end
