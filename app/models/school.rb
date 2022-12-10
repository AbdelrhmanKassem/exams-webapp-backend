class School < ApplicationRecord
  has_many :students
  validates :name, :governorate, :district, presence: true
end
