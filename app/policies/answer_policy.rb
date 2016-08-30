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
    user && user == record.user
  end

  def best?
    user.present? && (record.user != user) && (record.question.user == user )
  end

  def destroy?
    user && user == record.user
  end
end
