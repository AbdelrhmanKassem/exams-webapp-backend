# == Schema Information
#
# Table name: schools
#
#  id          :bigint           not null, primary key
#  name        :string
#  governorate :string
#  district    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class School < ApplicationRecord
  has_many :students
  validates :name, :governorate, :district, presence: true
end
