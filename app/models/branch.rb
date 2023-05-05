# == Schema Information
#
# Table name: branches
#
#  id   :bigint           not null, primary key
#  name :string           not null
#
class Branch < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  before_validation :lowercase_name

  has_many :exam_branches
  has_many :exams, through: :exam_branches
  has_many :students

  def lowercase_name
    self.name = name.downcase if name.present?
  end


  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  scope :order_on_student_count, lambda { |direction|
    joins(:students)
      .select('branches.*, COUNT(students.seat_number) AS student_count')
      .group('branches.id')
      .order("student_count #{direction}")
  }

  scope :order_on_exam_count, lambda { |direction|
    joins(:exams)
      .select('branches.*, COUNT(DISTINCT exams.id) AS exam_count')
      .group('branches.id')
      .order("exam_count #{direction}")
  }
end
