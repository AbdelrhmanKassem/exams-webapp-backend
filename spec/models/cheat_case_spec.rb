# == Schema Information
#
# Table name: cheat_cases
#
#  student_seat_number :bigint           not null, primary key
#  exam_id             :bigint           not null, primary key
#  proctor_id          :bigint           not null
#  notes               :text
#
require 'rails_helper'

RSpec.describe CheatCase, type: :model do
  context 'Associations' do
    it { should belong_to(:exam) }
    it { should belong_to(:student) }
    it { should belong_to(:proctor).class_name('User') }
  end
end
