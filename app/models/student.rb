# == Schema Information
#
# Table name: students
#
#  seat_number :bigint           not null, primary key
#  school_id   :bigint           not null
#  branch_id   :bigint           not null
#  full_name   :string           not null
#  email       :string
#
class Student < ApplicationRecord
  self.primary_key = 'seat_number'

  belongs_to :school
  belongs_to :branch
  has_many :grades

  EMAIL_REGEX = /\A([^-]+?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  before_validation :lowercase_email

  validates :full_name, :seat_number, presence: true
  validates :email, format: { with: EMAIL_REGEX }, unless: -> { email.blank? }
  validates :seat_number, numericality: { only_numeric: true, greater_than_or_equal_to: 0 }, uniqueness: true

  def lowercase_email
    self.email = email.downcase if email.present?
  end

  scope :school_name, ->(name) { joins(:school).where('schools.name = ?', name) }
  scope :district_id, ->(id) { joins(:school).where('schools.district_id = ?', id) }
  scope :branch_name, ->(name) { joins(:branch).where('branches.name = ?', name) }

  scope :search_by_full_name, ->(full_name) { where('full_name ILIKE ?', "%#{full_name}%") }

  scope :order_on_school_name, lambda { |direction|
    joins(:school)
      .select('students.*, schools.name AS school_name')
      .order("school_name #{direction}")
  }

  scope :order_on_branch_name, lambda { |direction|
    joins(:branch)
      .select('students.*, branches.name AS branch_name')
      .order("branch_name #{direction}")
  }
end
