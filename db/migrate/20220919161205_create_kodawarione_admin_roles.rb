class CreateKodawarioneAdminRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_roles do |t|
      t.string :role_type
      t.boolean :delete_flg, :default => false

      t.timestamps
    end
  end
end
