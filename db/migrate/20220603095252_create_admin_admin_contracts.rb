class CreateAdminAdminContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_contracts do |t|
      t.bigint :admin_id
      t.bigint :partner_id
      t.date :start_date
      t.date :end_date
      t.date :training_start_date
      t.date :training_end_date
      t.bigint :admin_plan_id
      t.bigint :payment_type
      t.timestamps
    end
  end
end
