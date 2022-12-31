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
class Exam < ApplicationRecord
  belongs_to :examiner, class_name: 'User'

  validates :examiner, :questions, :answers, :max_grade, :start_time, :exam_branches, presence: true
  # validates :branches, length: {
  #   minimum: 1,
  #   message: 'Must select atleast one branch'
  # }
  validates :max_grade, numericality: { greater_than_or_equal_to: 0 }
  # validate :valid_branches
  has_many :exam_branches
  # def valid_branches
  #   return unless branches.present?

  #   branches.each do |branch|
  #     errors.add(:branches, 'Invalid Branches Selected') unless Student.branches.include? branch
  #   end
  # end
end
