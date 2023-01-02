# == Schema Information
#
# Table name: password_reset_tokens
#
#  user_id    :bigint           not null, primary key
#  token_hash :string           not null
#
require 'rails_helper'

RSpec.describe PasswordResetToken, type: :model do
  context 'Presence tests' do
    %i[token_hash].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  context 'User Association' do
    it { is_expected.to belong_to(:user) }
  end
end
