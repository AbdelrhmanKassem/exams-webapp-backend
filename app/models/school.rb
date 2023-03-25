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
end
