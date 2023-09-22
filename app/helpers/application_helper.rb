module ApplicationHelper 
  def student_active_url(link_path)
    current_page?(link_path) ? "here show active" : ""
  end

  def company_active_url?(test_path)
    return 'show  text-active-primary active' if request.path == test_path

    ''
  end

  def partner_active_url?(link_path)
    current_page?(link_path) ? "here show active" : ""
  end

  def user_layout_check
    return true if current_page?(user_session_path) || current_page?(sign_in_sign_up_path) || current_page?(new_company_company_path) || current_page?(company_user_session_path) || current_page?(new_company_user_registration_path) || current_page?(new_user_registration_path) || (controller_name == "registrations" && action_name == "create") || (controller_name == "sessions" && action_name == "new") || (controller_name == "companies" && action_name == "create") || controller_name == "passwords" || action_name == "genuine_password" || action_name == "company_genuine_password" || action_name == "genuine_password_change"|| action_name == "company_genuine_password_change" || action_name == "create_genuie_password" || action_name == "new_genuie_password" || current_page?(welcome_registration_complete_path)
    
    false
  end

  def company_layout_check
    # company_commitment = current_company.company_commitment
    # return true if company_commitment.name_furikana != nil && 
    # company_commitment.name != nil &&
    # company_commitment.postal_code != nil &&
    # company_commitment.postalcode_city !=  nil && 
    # company_commitment.m_prefecture_id != nil && 
    # company_commitment.m_region_id != nil && 
    # company_commitment.address != nil &&  
    # company_commitment.established_date != nil 
    return true if current_company.company_name != nil && 
    current_company.postal_code != nil &&
    current_company.postalcode_city != nil &&
    current_company.postalcode_city !=  nil && 
    current_company.m_region_id != nil && 
    current_company.m_prefecture_id != nil && 
    current_company.address != nil &&  
    current_company.company_established != nil
    false
  end

  def contact_layout_check
    return true if action_name == "contact_index" || action_name == "contact_create"

    false
  end

  def check_user_type 
    if current_company_user
      return LogoutHistory.active_types["company"].to_i
    elsif current_user
      return LogoutHistory.active_types["user"].to_i
    end
  end

  def current_company
    if current_company_user
      return  Company::Company.find_by(id: current_company_user.company_member.company_id)
    end
  end
  
  def current_user_data 
    if current_company_user
      return current_company_user
    elsif current_user
      return current_user
    end
  end

  def get_permission_can_access(role_permission_object, permission_id)
    role_permission_object.find{|data|  data.permission_id == permission_id && data.can == true }.present? ? true : false
  end
  

end
