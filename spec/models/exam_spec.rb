# == Schema Information
#
# Table name: exams
#
#  id          :bigint           not null, primary key
#  examiner_id :bigint           not null
#  branches    :string           default([]), is an Array
#  questions   :json
#  answers     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  max_grade   :decimal(, )
#
require 'rails_helper'

RSpec.describe Exam, type: :model do
  context 'Presence tests' do
    %i[examiner questions answers branches].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end
  context 'Branches tests' do
    it { is_expected.to allow_value(['maths']).for(:branches) }
    it { is_expected.to allow_value(%w[maths science]).for(:branches) }
    it { is_expected.to allow_value(['science']).for(:branches) }

    it { is_expected.to_not allow_value(['']).for(:branches) }
    it { is_expected.to_not allow_value('maths').for(:branches) }
    it { is_expected.to_not allow_value(['math']).for(:branches) }
  end

  context 'Examiner Association' do
    it { should belong_to(:examiner).class_name('User') }
  end
end
