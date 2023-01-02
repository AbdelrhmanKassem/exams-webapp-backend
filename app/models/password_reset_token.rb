# == Schema Information
#
# Table name: password_reset_tokens
#
#  user_id    :bigint           not null, primary key
#  token_hash :string           not null
#
class PasswordResetToken < ApplicationRecord
  self.primary_key = 'user_id'
  
  validates :token_hash, presence: true

  belongs_to :user
end
