# == Schema Information
#
# Table name: cheat_cases
#
#  student_seat_number :bigint           not null, primary key
#  exam_id             :bigint           not null, primary key
#  proctor_id          :bigint           not null
#  notes               :text
#
class CheatCase < ApplicationRecord
  self.primary_keys = :student_seat_number, :exam_id

  belongs_to :exam
  belongs_to :student, class_name: 'Student', foreign_key: 'student_seat_number'
  belongs_to :proctor, class_name: 'User'
end
