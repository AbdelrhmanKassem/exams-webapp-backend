class DistrictPolicy < ApplicationPolicy
  def index?
    admin? || examiner?
  end
end
