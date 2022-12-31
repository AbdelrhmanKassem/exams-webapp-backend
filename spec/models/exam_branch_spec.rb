# == Schema Information
#
# Table name: exam_branches
#
#  exam_id :bigint           not null, primary key
#  branch  :enum             not null, primary key
#
require 'rails_helper'

RSpec.describe ExamBranch, type: :model do
  context 'Presence tests' do
    %i[branch].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end
  context 'Branches tests' do
    it { is_expected.to allow_value('math').for(:branch) }
    it { is_expected.to allow_value('literature').for(:branch) }
    it { is_expected.to allow_value('science').for(:branch) }

    it { is_expected.to_not allow_value(['']).for(:branch) }
    it { is_expected.to_not allow_value('maths').for(:branch) }
    it { is_expected.to_not allow_value('any thing').for(:branch) }
  end

  context 'Exam Association' do
    it { should belong_to(:exam) }
  end
end
