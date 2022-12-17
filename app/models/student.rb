class Student < ApplicationRecord
  include LiberalEnum

  EMAIL_REGEX = /\A([^-]+?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  belongs_to :school
  has_many :grades

  before_validation :lowercase_email
  before_validation :lowercase_username

  validates :email, :username, :full_name, :branch, :school, presence: true
  validates :email, format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :username, length: { minimum: 3, maximum: 30 }, uniqueness: { case_sensitive: false }
  enum branch: { maths: 'maths', science: 'science', literature: 'literature' }, _prefix: :branch

  liberal_enum :branch

  validates :branch, presence: true, inclusion: { in: branches.values }

  def lowercase_email
    self.email = email.downcase if email.present?
  end

  def lowercase_username
    self.username = username.downcase if username.present?
  end
end
