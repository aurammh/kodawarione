class CreateKodawarioneContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.bigint :contract_from_id
      t.bigint :contract_to_id
      t.bigint :contract_role_type, comment: 'admin=1, super_partner=2, partner=3'
      t.date :start_date
      t.date :end_date
      t.date :training_start_date
      t.date :training_end_date
      t.bigint :plan_id
      t.bigint :payment_type
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
