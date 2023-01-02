class RolePolicy < ApplicationPolicy
  def index?
    admin?
  end
end
