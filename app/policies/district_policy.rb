class DistrictPolicy < ApplicationPolicy
  def index?
    admin? || examiner?
  end

  def create?
    admin?
  end

  def list?
    admin? || examiner?
  end

  def destroy?
    admin?
  end
end
