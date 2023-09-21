class BranchPolicy < ApplicationPolicy
  def index?
    admin? || examiner?
  end

  def create?
    admin?
  end

  def destroy?
    admin?
  end
end
