module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_path
  end

  protected

  def check_path
    if admin_signed_in?
      redirect_to(admin_dashboard_index_path) and return
      # redirect_to(kodawarione_dashboard_index_path) and return
    end

    if company_user_signed_in?
      permission = Admin::Permission.find_by(admin_permission_type_id: 1, user_type: 2, company_user_id: current_company_user.id)
      if permission.nil?
        check_company == true ? redirect_to(company_companies_path) : redirect_to(edit_company_company_commitment_path(current_company.id)) 
      else
        CompanyUsers::SessionsController.set_activeFlag(true)
        sign_out(current_company_user)
        # current_user.invalidate_all_sessions!
        redirect_to company_user_logout_path and return
      end
    end
    if user_signed_in?
      permission = Admin::Permission.find_by(admin_permission_type_id: 1, user_type: 1, user_id: current_user.id)
      if permission.nil?
        check_student == true ? redirect_to(student_commitment_steps_path) : redirect_to(student_students_path)
      else
        Users::SessionsController.set_activeFlag(true)
        sign_out(current_user)
        redirect_to logout_path and return
      end
    end
  end

  def check_student
    @user_data.nick_name.nil? ? true : false
  end

  def check_company
    current_company.company_name != nil && 
    current_company.postal_code != nil &&
    current_company.postalcode_city != nil &&
    current_company.postalcode_city !=  nil && 
    current_company.m_region_id != nil && 
    current_company.m_prefecture_id != nil && 
    current_company.address != nil &&  
    current_company.company_established != nil
  end

  def check_partner_user
    current_partner_user.email.nil? ? true : false
  end

  def check_super_partner_user
    current_super_partner_user.email.nil? ? true : false
  end
end
