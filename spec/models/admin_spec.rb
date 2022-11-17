require 'rails_helper'
RSpec.describe Admin, type: :model do
  context 'Presence tests' do
    %i[username first_name last_name email password].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'username tests' do
    it { should validate_length_of(:username).is_at_least(3) }
    it { should validate_length_of(:username).is_at_most(30) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  context 'Password validation test' do
    it { should validate_length_of(:password).is_at_least(8) }
    it { should validate_length_of(:password).is_at_most(50) }
    it { is_expected.to allow_value('Test@123123').for(:password) }
    it { is_expected.to_not allow_value('psw@123123').for(:password) }
    it { is_expected.to_not allow_value('PSW@123123').for(:password) }
    it { is_expected.to_not allow_value('PSW123123').for(:password) }
    it { is_expected.to_not allow_value('PSW@aaaaaa').for(:password) }
    it { is_expected.to_not allow_value('PSWa @123123').for(:password) }
  end

  context 'Email validation' do
    it { is_expected.to allow_value('email@addresse.com').for(:email) }
    it { is_expected.to_not allow_value('ak@gmail').for(:email) }
    it { is_expected.to_not allow_value('ak@gmail.c@').for(:email) }
    it { is_expected.to_not allow_value('ak$-@gmail.com').for(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
end
