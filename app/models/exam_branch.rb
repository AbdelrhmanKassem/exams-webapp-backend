# == Schema Information
#
# Table name: exam_branches
#
#  exam_id :bigint           not null, primary key
#  branch  :enum             not null, primary key
#
class ExamBranch < ApplicationRecord
  include LiberalEnum
  belongs_to :exam
  validates :branch, presence: true, inclusion: { in: Student.branches.values }
end
