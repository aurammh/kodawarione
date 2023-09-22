class ApplicationController < ActionController::Base
  before_action :set_user
  before_action :permission_list
  # before_action :authorize_company! ,if: :company_user_signed_in?
  layout :layout_by_resource
  include CommonHelper
  include ProgressHelper
  # def after_sign_in_path_for(resource)
  #   if resource.user_type == 2
  #     student = resource.student
  #     return (edit_student_student_path(student))
  #   else
  #     company = resource.company
  #     return (edit_company_company_path(company))
  #   end
  # end  

  def layout_by_resource
    if user_signed_in?
      'layouts/template/student' 
    elsif company_user_signed_in?
      'layouts/template/company'
    end
  end


  def check_user_type 
    if current_company_user
      return LogoutHistory.active_types["company"].to_i
    elsif current_user
      return LogoutHistory.active_types["user"].to_i
    end
  end

  def current_user_data 
    if current_company_user
      return current_company_user
    elsif current_user
      return current_user
    end
  end

  def current_company
    if current_company_user
      return  Company::Company.find_by(id: current_company_user.company_member.company_id)
    end
  end

  def current_admin_type
    if current_admin
      if current_admin.chief_administrator?

      elsif current_admin.super_partner?
        return Kodawarione::SuperPartner.find_by(id: current_admin.admin_member.super_partners_id)
      elsif current_admin.partner?
        return Kodawarione::SuperPartner.find_by(id: current_admin.admin_member.partner_id)
      end
    end
  end

  def authorize_user!
    unless check_user_type == LogoutHistory.active_types["user"].to_i
      redirect_to welcome_index_path
    else 
      return true
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    if current_company_user
      render file: Rails.public_path.join('403.html'), status: :not_found, layout: false
    else
      respond_to do |format|
        format.json { render nothing: true, status: :not_found }
        format.html { redirect_to file: Rails.public_path.join('403.html'), alert: exception.message }
        format.js   { render nothing: true, status: :not_found }
      end
    end
  end

  protected
  def authorize_company!
    method_name = "#{controller_name}/#{action_name}"
    ignore_create = "#{controller_name}/create"
    ignore_update = "#{controller_name}/update"
    if current_company_user.company_member.company_roles.role_type == "admin"
      return true
    else
      role = current_company_user.company_member.company_roles.role_permission.map{|role| role.permission_id}
      permission = Company::Permission.all.map{|permission|  permission.controller_name if role.include? permission.id }
      if (permission.include?  method_name ) || (except_action.include?  method_name ) || (ignore_create.eql? method_name ) ||(ignore_update.eql?  method_name )
        return true
      else 
        flash[:unauthorize] = 1
        redirect_back fallback_location: "#{request.env["HTTP_REFERER"]}"
      end
    end
  end
  
  private
  def member_role_type(control_name)
    member_role_type =  Company::RolePermission.where(role_id: Company::CompanyMember.find_by(user_email: current_company_user.email , company_id: current_company.id).company_roles_id).map{ |role_per| role_per.permission_id }
    return Company::Permission.where(id: member_role_type, controller_name: control_name).map{ |per| per.permission_type }
  end

  def set_user
    if company_user_signed_in?
      @user_data = Company::Company.find_by(id: current_company_user.company_member.company_id)
    end
    if user_signed_in?
      @user_data = current_user.student
    end
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path
    elsif resource_or_scope == :partner_user
      active_flag = Partner::PartnerUsers::SessionsController.get_activeFlag
      if active_flag
        flash[:active_flag] = I18n.t('admin.setting.active_login_msg')
        Partner::PartnerUsers::SessionsController.set_activeFlag(false)
        new_partner_user_session_path
      else
        new_partner_user_session_path
      end
    elsif resource_or_scope == :super_partner_user  
      active_flag = SuperPartnerUsers::SessionsController.get_activeFlag
      if active_flag
        flash[:active_flag] = I18n.t('admin.setting.active_login_msg')
        SuperPartnerUsers::SessionsController.set_activeFlag(false)
        new_super_partner_user_session_path
      else
        new_super_partner_user_session_path
      end
    else
      if resource_or_scope == :user
        active_flag = Users::SessionsController.get_activeFlag
        if active_flag
          flash[:active_flag] = I18n.t('admin.setting.active_login_msg')
          Users::SessionsController.set_activeFlag(false)
          new_user_session_path
        else
          root_path
        end
       elsif  resource_or_scope == :company_user
        active_flag =  CompanyUsers::SessionsController.get_activeFlag
        if active_flag
          flash[:active_flag] = I18n.t('admin.setting.active_login_msg')
          CompanyUsers::SessionsController.set_activeFlag(false)
          new_company_user_session_path
        else
          new_company_user_session_path
        end
       else
        root_path
       end
    end
  end

  def permission_list
    @permission_type = Admin::MPermissionType.select('admin_m_permission_types.permission_type,admin_permissions.*').joins(:permission)
  end
end
