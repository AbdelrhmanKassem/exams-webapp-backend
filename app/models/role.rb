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
  has_many :users

  before_validation :lowercase_name
  def lowercase_name
    self.name = name.downcase if name.present?
  end

  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  scope :order_on_user_count, lambda { |direction|
    joins(:users)
      .select('roles.*, COUNT(users.id) AS user_count')
      .group('roles.id')
      .order("user_count #{direction}")
  }

end
