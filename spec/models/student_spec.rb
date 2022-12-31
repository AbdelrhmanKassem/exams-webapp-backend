# == Schema Information
#
# Table name: students
#
#  username    :string
#  full_name   :string
#  email       :string
#  seat_number :bigint           not null, primary key
#  branch      :enum
#  school_id   :bigint           not null
#
require 'rails_helper'

RSpec.describe Student, type: :model do
  context 'Presence tests' do
    %i[email username full_name school branch seat_number].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'username tests' do
    subject { FactoryBot.create(:student) }
    it { should validate_length_of(:username).is_at_least(3) }
    it { should validate_length_of(:username).is_at_most(30) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  context 'Email validation' do
    subject { FactoryBot.create(:student) }
    it { is_expected.to allow_value('email@addresse.com').for(:email) }
    it { is_expected.to_not allow_value('ak@gmail').for(:email) }
    it { is_expected.to_not allow_value('ak@gmail.c@').for(:email) }
    it { is_expected.to_not allow_value('ak$-@gmail.com').for(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  context 'Seat Number validation' do
    subject { FactoryBot.create(:student) }
    it { is_expected.to allow_value('123').for(:seat_number) }
    it { is_expected.to allow_value(123).for(:seat_number) }
    it { is_expected.to_not allow_value('-123').for(:seat_number) }
    it { is_expected.to_not allow_value('AABB123').for(:seat_number) }
    it { should validate_uniqueness_of(:seat_number) }
  end

  context 'Branch tests' do
    it { should validate_inclusion_of(:branch).in?(Student.branches.keys) }
    it { is_expected.to allow_value('math').for(:branch) }
    it { is_expected.to allow_value('science').for(:branch) }
    it { is_expected.to allow_value('literature').for(:branch) }
  end

  context 'School Association' do
    it { should belong_to(:school) }
  end
end
