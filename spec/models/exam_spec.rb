# == Schema Information
#
# Table name: exams
#
#  id          :bigint           not null, primary key
#  examiner_id :bigint           not null
#  questions   :json
#  answers     :text
#  start_time  :datetime
#  max_grade   :decimal(, )
#
require 'rails_helper'

RSpec.describe Exam, type: :model do
  context 'Presence tests' do
    %i[examiner questions answers exam_branches].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'Examiner Association' do
    it { should belong_to(:examiner).class_name('User') }
  end
end
