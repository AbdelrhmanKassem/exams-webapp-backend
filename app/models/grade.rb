class Grade < ApplicationRecord
  belongs_to :student
  belongs_to :exam

  validates :student, :exam, :mark, presence: true

  validates :mark, numericality: { greater_than_or_equal_to: 0 }

  # TODO: validate mark is less than or equal exam.max_grade
end
