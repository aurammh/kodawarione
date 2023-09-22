class CreateEventWait < ActiveRecord::Migration[6.1]
  def change
    create_table :event_waits do |t|
      t.bigint :event_id
      t.bigint :join_user_type , comment: ' company=1, student=2, partner=3, admin=4 , super_partner=5'
      t.bigint :user_id
      t.bigint :company_id
      t.bigint :company_user_id
      t.bigint :partner_id
      t.bigint :partner_user_id
      t.bigint :super_partner_id
      t.bigint :super_partner_user_id
      t.date :join_date
      t.bigint :approver_user_type , comment: ' company=1, student=2, partner=3, admin=4 , super_partner=5'
      t.bigint :approver_id
      t.bigint :approver_user_id
      t.date :approve_date
      t.boolean :join_flg, default: false
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
