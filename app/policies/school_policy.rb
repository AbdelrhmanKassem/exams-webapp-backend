class SchoolPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    admin?
  end
end
