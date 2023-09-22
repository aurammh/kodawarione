module Kodawarione::CompanyManage::CompanyHelper
    def get_open_job_count(company_id)
        Company::Vacancy.where("company_id = ? AND published_flg = ? AND CURRENT_DATE BETWEEN display_from AND display_to", company_id, true).size
    end

    def get_event_count(company_id)
        Event.where("created_by_id = ? AND event_type = ? AND delete_flg = ?", company_id, 1, false).size
    end

    def get_member_list(company_id)
        Company::CompanyMember.select('company_members.*,company_users.first_name, company_users.last_name,company_roles.role_type').left_outer_joins(:company_users).left_outer_joins(:company_roles).where("company_members.company_id = ? AND join_flag = ? AND NOT user_id = ? AND company_users.last_name IS NOT NULL",company_id,true, company_id).order("company_roles.id") 
    end
end
