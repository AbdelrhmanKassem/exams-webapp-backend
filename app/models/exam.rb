class Exam < ApplicationRecord
  belongs_to :examiner, class_name: 'Admin'

  validates :examiner, :questions, :answers, :branches, :max_grade, presence: true
  validates :branches, length: {
    minimum: 1,
    message: 'Must select atleast one branch'
  }
  validates :max_grade, numericality: { greater_than_or_equal_to: 0 }
  validate :valid_branches

  def valid_branches
    return unless branches.present?

    branches.each do |branch|
      errors.add(:branches, 'Invalid Branches Selected') unless Student.branches.include? branch
    end
  end
end
