class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user
  end

  def update?
    user && user.author_of?(record)
  end

  def best?
    user.present? && !user.author_of?(record) && user.author_of?(record.question)
  end

  def destroy?
    user && user.author_of?(record)
  end
end
