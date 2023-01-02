class BranchPolicy < ApplicationPolicy
  def index?
    admin? || examiner?
  end
end
