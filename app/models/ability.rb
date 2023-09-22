# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Admin)
      if user.chief_administrator?
        can :manage, :all
      elsif user.super_partner?
        # can :manage, :all
        Kodawarione::RolePermission.select("*").permissions.where(can: true, role_id: 2).where("permissions.permission_for= 1").each do |permission|
          can permission.action_name.to_sym, permission.permission_model_name.constantize
        end
        # can :manage, :all
      elsif user.partner?
        # can [:read, :create, :update], Company::Vacancy
        Kodawarione::RolePermission.select("*").permissions.where(can: true, role_id: 3).where("permissions.permission_for= 1").each do |permission|
          can permission.action_name.to_sym, permission.permission_model_name.constantize
        end
        # can :manage, :all
      else
        can :manage, :all
      end
    elsif user.is_a?(CompanyUser)
      if user.chief_administrator?
        can :manage, :all
      elsif user.admin?
        # can :manage, :all
        Kodawarione::RolePermission.select("*").permissions.where(can: true, role_id: 2).where("permissions.permission_for= 4").each do |permission|
          can permission.action_name.to_sym, permission.permission_model_name.constantize
        end
      elsif user.member?
        # can [:read, :create, :update], Company::Vacancy
        Kodawarione::RolePermission.select("*").permissions.where(can: true, role_id: 3).where("permissions.permission_for= 4").each do |permission|
          can permission.action_name.to_sym, permission.permission_model_name.constantize
        end
      else
        can :manage, :all
      end
    else
      # add guest permissions only
      can :manage, :all
    end
  end
end
