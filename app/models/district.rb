# == Schema Information
#
# Table name: districts
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  governorate :string           not null
#
class District < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :governorate, presence: true

  has_many :schools
  
  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  scope :order_on_school_count, lambda { |direction|
    joins(:schools)
      .select('districts.*, COUNT(schools.id) AS school_count')
      .group('districts.id')
      .order("school_count #{direction}")
  }
end
