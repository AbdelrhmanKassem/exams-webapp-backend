# == Schema Information
#
# Table name: roles
#
#  id   :bigint           not null, primary key
#  name :string           not null
#
class Role < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  
  before_validation :lowercase_name
  def lowercase_name
    self.name = name.downcase if name.present?
  end
end
