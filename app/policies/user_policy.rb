class UserPolicy < ApplicationPolicy

  def index?
    admin?
  end

  def create?
    admin?
  end
end
