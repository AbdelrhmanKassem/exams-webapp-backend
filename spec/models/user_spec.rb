require 'rails_helper'
RSpec.describe User, type: :model do
  context 'Presence tests' do
    %i[username first_name last_name email role].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'username tests' do
    it { should validate_length_of(:username).is_at_least(3) }
    it { should validate_length_of(:username).is_at_most(30) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  context 'Email validation' do
    it { is_expected.to allow_value('email@addresse.com').for(:email) }
    it { is_expected.to_not allow_value('ak@gmail').for(:email) }
    it { is_expected.to_not allow_value('ak@gmail.c@').for(:email) }
    it { is_expected.to_not allow_value('ak$-@gmail.com').for(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  context 'Role validation' do
    it { should validate_inclusion_of(:role).in?(User.roles.keys) }
    it { is_expected.to allow_value('admin').for(:role) }
  end
end