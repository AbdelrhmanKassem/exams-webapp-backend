# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  username               :string
#  first_name             :string
#  last_name              :string
#  role                   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  jti                    :string           not null
#
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include LiberalEnum


  devise :database_authenticatable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  devise :invitable, invite_for: nil, validate_on_invite: true

  has_many :exams

  EMAIL_REGEX =  /\A([^-]+?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  PASSWORD_REGEX = /(?=.*[A-Za-z])(?=.*\d){8,}/

  before_validation :set_default_password, on: :create
  before_validation :lowercase_email
  before_validation :lowercase_username

  validates :email, :username, :first_name, :last_name, :password, :role, presence: true
  validates :email, format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :username, length: { minimum: 3, maximum: 30 }, uniqueness: { case_sensitive: false }
  validates :password, allow_nil: true, format: { with: PASSWORD_REGEX }
  validates :password, length: { minimum: 8, maximum: 50 }

  enum role: { admin: 'admin', examiner: 'examiner' }
  liberal_enum :role

  validates :role, presence: true, inclusion: { in: roles.values }


  # Can be used to add something to the JWT paylaod
  def jwt_payload
    super.merge({ 'foo' => 'bar' })
  end

  def lowercase_email
    self.email = email.downcase if email.present?
  end

  def lowercase_username
    self.username = username.downcase if username.present?
  end

  def set_default_password
    self.password = Devise.friendly_token.first(18) + ('a'..'z').to_a.sample + ('0'..'9').to_a.sample unless password
  end
end
