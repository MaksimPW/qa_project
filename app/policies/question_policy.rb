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
    user && user.author_of?(record)
  end

  def destroy?
    user && user.author_of?(record)
  end
end
