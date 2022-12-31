# == Schema Information
#
# Table name: schools
#
#  id          :bigint           not null, primary key
#  name        :string
#  governorate :string
#  district    :string
#
class School < ApplicationRecord
  has_many :students
  validates :name, :governorate, :district, presence: true
end
