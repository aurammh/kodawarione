class CreateRolePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :role_permissions do |t|
      t.bigint :role_id
      t.bigint :permission_id
      t.boolean :can
      
      t.timestamps
    end
  end
end
