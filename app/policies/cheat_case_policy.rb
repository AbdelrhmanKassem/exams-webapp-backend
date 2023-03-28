class ChearCasePolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    proctor?
  end
end
