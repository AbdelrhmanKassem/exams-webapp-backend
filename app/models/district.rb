# == Schema Information
#
# Table name: districts
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  governorate :string           not null
#
class District < ApplicationRecord
  validates :name, :governorate, presence: true, uniqueness: { case_sensitive: false }

  has_many :schools
end
