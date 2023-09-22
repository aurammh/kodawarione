class Kodawarione::Contract < ApplicationRecord
    self.table_name = "contracts"

    validates :contract_to_id, presence: true, on: [:create, :update]
    validates :start_date, presence: true, on: [:create, :update]
    validates :end_date, presence: true, on: [:create, :update]
    validates :plan_id, presence: true
    validates :payment_type, presence: true
    validates :training_start_date, presence: true, on: [:create, :update]
    validates :training_end_date, presence: true, on: [:create, :update]

    #enum for payment options
    enum payment_type: {all_in: 1, monthly: 2}
end
