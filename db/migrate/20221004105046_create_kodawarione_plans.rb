class CreateKodawarionePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.bigint :plan_role_type, comment: 'admin=1, super_partner=2, partner=3'
      t.bigint :created_id, comment:'admin_id, super_partner_id, partner_id'      
      t.string :name, limit: 100
      t.text :content, limit: 1500
      t.bigint :fee
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
