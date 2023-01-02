# == Schema Information
#
# Table name: students
#
#  seat_number :bigint           not null, primary key
#  school_id   :bigint           not null
#  branch_id   :bigint           not null
#  full_name   :string           not null
#  email       :string
#
require 'rails_helper'

RSpec.describe Student, type: :model do
  context 'Presence tests' do
    %i[full_name seat_number].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'Email validation' do
    subject { FactoryBot.create(:student) }
    it { is_expected.to allow_value('email@addresse.com').for(:email) }
    it { is_expected.to allow_value('').for(:email) }
    it { is_expected.to_not allow_value('ak@gmail').for(:email) }
    it { is_expected.to_not allow_value('ak@gmail.c@').for(:email) }
    it { is_expected.to_not allow_value('ak$-@gmail.com').for(:email) }
  end

  context 'Seat Number validation' do
    subject { FactoryBot.create(:student) }
    it { is_expected.to allow_value('123').for(:seat_number) }
    it { is_expected.to allow_value(123).for(:seat_number) }
    it { is_expected.to_not allow_value('-123').for(:seat_number) }
    it { is_expected.to_not allow_value('AABB123').for(:seat_number) }
    it { should validate_uniqueness_of(:seat_number) }
  end

  context 'Branch Association' do
    it { should belong_to(:branch) }
  end

  context 'School Association' do
    it { should belong_to(:school) }
  end
end
