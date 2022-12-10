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
    it { should belong_to(:examiner).class_name('Admin') }
  end
end
