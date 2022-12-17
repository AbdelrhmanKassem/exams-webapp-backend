class UserPolicy < ApplicationPolicy
  def create?
    admin?
  end
end
