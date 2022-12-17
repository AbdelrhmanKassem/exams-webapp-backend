class SchoolPolicy < ApplicationPolicy
  def create?
    admin?
  end
end
