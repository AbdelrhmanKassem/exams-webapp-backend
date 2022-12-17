class StudentPolicy < ApplicationPolicy
  def create?
    admin?
  end
end
