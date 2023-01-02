# == Schema Information
#
# Table name: exam_branches
#
#  exam_id   :bigint           not null, primary key
#  branch_id :bigint           not null, primary key
#
class ExamBranch < ApplicationRecord
  self.primary_keys = :exam_id, :branch_id

  belongs_to :exam
  belongs_to :branch
end
