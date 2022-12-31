# == Schema Information
#
# Table name: grades
#
#  student_seat_number :bigint           not null, primary key
#  exam_id             :bigint           not null, primary key
#  mark                :decimal(, )
#
class Grade < ApplicationRecord
  self.primary_keys = :student_seat_number, :exam_id
  belongs_to :student, class_name: 'Student', foreign_key: 'student_seat_number'

  belongs_to :exam

  validates :student, :exam, :mark, presence: true

  validates :mark, numericality: { greater_than_or_equal_to: 0 }

  # TODO: validate mark is less than or equal exam.max_grade
end
