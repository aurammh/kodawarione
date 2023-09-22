module Admin::AdminContractsHelper
    def payment_options
        Admin::AdminContract.payment_types.keys.map{ |k| [t("payment_type.#{k}"), k] }
    end

    def get_admin_plan_name(admin_plan_id)
        Admin::AdminPlan.find(admin_plan_id).name
    end

    def get_admin_partner_name(partner_id)
        Partner::Partner.find(partner_id).name
    end
end
