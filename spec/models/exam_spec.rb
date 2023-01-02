# == Schema Information
#
# Table name: exams
#
#  id          :bigint           not null, primary key
#  examiner_id :bigint           not null
#  start_time  :datetime         not null
#  end_time    :datetime         not null
#  max_grade   :decimal(, )      not null
#  questions   :text             not null
#  answers     :text             not null
#
require 'rails_helper'

RSpec.describe Exam, type: :model do
  context 'Presence tests' do
    %i[examiner questions answers start_time end_time max_grade].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'Examiner Association' do
    it { should belong_to(:examiner).class_name('User') }
  end

  context 'Branch Association' do
    it { should have_many(:branches) }
  end

  context 'Time' do
    it { is_expected.to allow_value(Time.current + 100).for(:start_time) }
    it { is_expected.to allow_value(Time.current + 5.hours).for(:start_time) }
    it { is_expected.to_not allow_value(Time.current - 100).for(:start_time) }
    it { is_expected.to_not allow_value(Time.current - 5.hours).for(:start_time) }
    it { is_expected.to_not allow_value(Time.current - 5.hours).for(:start_time) }
  end
end
