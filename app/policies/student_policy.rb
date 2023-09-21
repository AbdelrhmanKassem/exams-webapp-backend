class StudentPolicy < ApplicationPolicy
  def create?
    admin?
  end

  def index?
    admin?
  end

  def bulk_upload?
    admin?
  end

  def destroy?
    admin?
  end

end
