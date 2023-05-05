# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  role_id            :bigint           not null
#  full_name          :string           not null
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  jti                :string           not null
#
require 'rails_helper'
RSpec.describe User, type: :model do
  context 'Presence tests' do
    %i[full_name email].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'Email validation' do
    subject { FactoryBot.create(:user) }
    it { is_expected.to allow_value('email@addresse.com').for(:email) }
    it { is_expected.to_not allow_value('ak@gmail').for(:email) }
    it { is_expected.to_not allow_value('ak@gmail.c@').for(:email) }
    it { is_expected.to_not allow_value('ak$-@gmail.com').for(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  context 'Role Association' do
    it { should belong_to(:role) }
  end
end
