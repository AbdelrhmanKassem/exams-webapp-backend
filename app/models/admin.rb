class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,:recoverable, :validatable,
         :invitable, invite_for: nil, validate_on_invite: true

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
