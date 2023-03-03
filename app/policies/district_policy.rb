class DistrictPolicy < ApplicationPolicy
  def index?
    admin? || examiner?
  end

  def create?
    admin?
  end
end
