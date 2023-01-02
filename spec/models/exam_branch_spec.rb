# == Schema Information
#
# Table name: exam_branches
#
#  exam_id   :bigint           not null, primary key
#  branch_id :bigint           not null, primary key
#
require 'rails_helper'

RSpec.describe ExamBranch, type: :model do
  context 'Exam Association' do
    it { should belong_to(:exam) }
  end

  context 'branch Association' do
    it { should belong_to(:branch) }
  end
end
