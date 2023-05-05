# == Schema Information
#
# Table name: schools
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  district_id :bigint           not null
#
class School < ApplicationRecord
  has_many :students

  belongs_to :district

  validates :name, presence: true

  scope :district_name, ->(name) { joins(:district).where('districts.name = ?', name) }
  scope :governorate, ->(name) { joins(:district).where('districts.governorate = ?', name) }
  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  scope :order_on_student_count, lambda { |direction|
    joins(:students)
      .select('schools.*, COUNT(students.seat_number) AS student_count')
      .group('schools.id')
      .order("student_count #{direction}")
  }

  scope :order_on_district_name, lambda { |direction|
    joins(:district)
      .select('schools.*, districts.name AS district_name')
      .order("district_name #{direction}")
  }

  scope :order_on_governorate, lambda { |direction|
    joins(:district)
      .select('schools.*, districts.governorate AS governorate')
      .order("governorate #{direction}")
  }

end
