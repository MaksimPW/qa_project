class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    user
  end

  def create?
    user
  end

  def update?
    user && user == record.user
  end

  def destroy?
    user && user == record.user
  end
end
