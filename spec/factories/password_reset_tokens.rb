# == Schema Information
#
# Table name: password_reset_tokens
#
#  user_id    :bigint           not null, primary key
#  token_hash :string           not null
#
FactoryBot.define do
  factory :password_reset_token do
    user
    token_hash { Faker::Number.hexadecimal(digits: 64) }
  end
end
