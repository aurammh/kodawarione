class Admin::AdminContract < ApplicationRecord
    self.table_name = "admin_contracts"

    validates :partner_id, presence: true, on: [:create, :update]
    validates :start_date, presence: true, on: [:create, :update]
    validates :end_date, presence: true, on: [:create, :update]
    validates :admin_plan_id, presence: true
    validates :payment_type, presence: true
    validates :training_start_date, presence: true, on: [:create, :update]
    validates :training_end_date, presence: true, on: [:create, :update]
    #enum for payment options
    enum payment_type: {all_in: 1, monthly: 2}

    #get admin count by plan
    def get_admin_count_by_plan()
        Admin::AdminContract.select("(admin_plans.name) AS plan_name, count(admin_plans.id)")
        .joins("LEFT JOIN admin_plans on admin_plans.id = admin_contracts.admin_plan_id")
        .group('admin_plans.id, admin_plans.name')
        .order('admin_plans.id')
    end
end
