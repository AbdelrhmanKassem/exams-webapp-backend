# == Schema Information
#
# Table name: exam_branches
#
#  exam_id   :bigint           not null, primary key
#  branch_id :bigint           not null, primary key
#
class ExamBranch < ApplicationRecord
  self.primary_keys = :exam_id, :branch_id
  validates_uniqueness_of :exam_id, scope: [:branch_id]
  validates_uniqueness_of :branch_id, scope: [:exam_id]
  
  belongs_to :exam
  belongs_to :branch
end
