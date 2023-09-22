class CreateAdminPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_permissions do |t|
      t.belongs_to :user
      t.bigint :company_id
      t.bigint :company_user_id
      t.bigint :partner_id
      t.bigint :partner_user_id
      t.bigint :super_partner_id
      t.bigint :super_partner_user_id
      t.belongs_to :admin_permission_type
      t.integer :user_type
      t.string :create_user
      t.cidr :ip_address
      t.timestamps
    end
  end
end
