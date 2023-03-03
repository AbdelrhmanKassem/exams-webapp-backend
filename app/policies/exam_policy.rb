class ExamPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if admin?
        scope.all
      elsif examiner?
        scope.where(examiner: user)
      else
        scope.none
      end
    end
  end

  def index?
    admin? || examiner?
  end

  def create?
    examiner?
  end

  def show?
    examiner? && record.examiner == user
  end

  def update?
    examiner? && record.examiner == user
  end
end
