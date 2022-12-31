# == Schema Information
#
# Table name: exam_branches
#
#  exam_id :bigint           not null, primary key
#  branch  :enum             not null, primary key
#
FactoryBot.define do
  factory :exam_branch do
    exam
    branch { Student.branches.keys.sample }
  end
end
