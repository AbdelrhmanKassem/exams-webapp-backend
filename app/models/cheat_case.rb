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

  validate :student_has_exam

  def student_has_exam
    if exam.present? && student.present?
      unless exam.branches.include?(student.branch)
        errors.add(:student, 'Student and Exam combination is invalid')
      end
    end
  end

  scope :order_on_proctor_name, lambda { |direction|
    joins(:proctor)
      .select('cheat_cases.*, users.full_name AS proctor_name')
      .order("proctor_name #{direction}")
  }

  scope :order_on_exam_name, lambda { |direction|
    joins(:exam)
      .select('cheat_cases.*, exams.name AS exam_name')
      .order("exam_name #{direction}")
  }

  scope :order_on_student_name, lambda { |direction|
    joins(:student)
      .select('cheat_cases.*, student.full_name AS student_name')
      .order("student_name #{direction}")
  }
end
