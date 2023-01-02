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

  def lowercase_name
    self.name = name.downcase if name.present?
  end
end
