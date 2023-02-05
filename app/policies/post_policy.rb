class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user&.is_admin? || record.published? || user == record.user
  end

  def create?
    user.present?
  end

  def update?
    user&.is_admin? || user == record.user
  end

  def destroy?
    user&.is_admin? || user == record.user
  end

  class Scope < Scope
    def resolve
      if user.present?
        scope.where(user:).or(scope.where(published: true))
      else
        scope.where(published: true)
      end
    end
  end
end
