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
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :exams
  belongs_to :role

  EMAIL_REGEX =  /\A([^-]+?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  PASSWORD_REGEX = /(?=.*[A-Za-z])(?=.*\d){8,}/

  before_validation :set_default_password, on: :create
  before_validation :lowercase_email

  validates :email, :full_name, :password, presence: true
  validates :email, format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, allow_nil: true, format: { with: PASSWORD_REGEX }
  validates :password, length: { minimum: 8, maximum: 50 }

  # Can be used to add something to the JWT paylaod
  def jwt_payload
    super.merge({ 'foo' => 'bar' })
  end

  def lowercase_email
    self.email = email.downcase if email.present?
  end

  def set_default_password
    self.password = Devise.friendly_token.first(18) + ('a'..'z').to_a.sample + ('0'..'9').to_a.sample unless password
  end

  scope :search_by_email, ->(email) { where('email ILIKE ?', "%#{email}%") }
  scope :search_by_full_name, ->(full_name) { where('full_name ILIKE ?', "%#{full_name}%") }
  scope :role_name, ->(name) { joins(:role).where('roles.name = ?', name) }

  scope :order_on_role_name, lambda { |direction|
    joins(:role)
      .select('users.*, roles.name AS role_name')
      .order("role_name #{direction}")
  }

end
