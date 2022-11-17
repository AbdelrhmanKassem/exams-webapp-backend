class Examiner < ApplicationRecord
  EMAIL_REGEX =  /\A([^-]+?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  PASSWORD_REGEX = /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z\d])(?!.*\s).*\z/

  has_secure_password
  before_validation :lowercase_email
  before_validation :lowercase_username

  validates :email, :username, :first_name, :last_name, :password, presence: true
  validates :email, format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :username, length: { minimum: 3, maximum: 30 }, uniqueness: { case_sensitive: false }
  validates :password, format: { with: PASSWORD_REGEX }
  validates :password, length: { minimum: 8, maximum: 50 }

  def lowercase_email
    self.email = email.downcase if email.present?
  end

  def lowercase_username
    self.username = username.downcase if username.present?
  end
end
