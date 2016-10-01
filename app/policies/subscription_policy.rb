class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user
  end

  def destroy?
    user && user.author_of?(record)
  end
end
