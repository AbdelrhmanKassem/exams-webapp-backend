require 'rails_helper'

RSpec.describe Grade, type: :model do
  context 'Presence tests' do
    %i[mark].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end
  context 'Mark Association' do
    it { is_expected.to allow_value(0).for(:mark) }
    it { is_expected.to allow_value(0.0).for(:mark) }
    it { is_expected.to allow_value(0.1).for(:mark) }
    it { is_expected.to allow_value(100.1).for(:mark) }
    it { is_expected.to allow_value(200).for(:mark) }
    it { is_expected.to allow_value(5000).for(:mark) }
    it { is_expected.to allow_value(0).for(:mark) }

  end
  context 'Student Association' do
    it { is_expected.to belong_to(:student) }
  end
  context 'Exam Association' do
    it { is_expected.to belong_to(:exam) }
  end
end
