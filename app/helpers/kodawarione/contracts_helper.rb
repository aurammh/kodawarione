module Kodawarione::ContractsHelper
    def get_admin_plan_name(plan_id)
        Kodawarione::Plan.find(plan_id).name
    end

    def get_super_partner_name(contract_to_id)
        Admin::SuperPartner.find(contract_to_id).name
    end

    def get_partner_name(contract_to_id)
        Partner::Partner.find(contract_to_id).name
    end

    def get_company_name(contract_to_id)
        Company::Company.find(contract_to_id).name
    end
end
