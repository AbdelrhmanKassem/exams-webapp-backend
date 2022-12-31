class ExamBranch < ApplicationRecord
  include LiberalEnum
  belongs_to :exam
  validates :branch, presence: true, inclusion: { in: Student.branches.values }
end
