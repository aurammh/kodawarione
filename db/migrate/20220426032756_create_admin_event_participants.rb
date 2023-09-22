class CreateAdminEventParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_event_participants do |t|
      t.belongs_to :admin_event
      t.bigint :company_id
      t.bigint :company_user_id
      t.bigint :user_id
      t.bigint :partner_id
      t.bigint :partner_user_id
      t.bigint :super_partner_id
      t.bigint :super_partner_user_id
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
