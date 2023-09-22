class CreateKodawarioneAdminMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_members do |t|
      t.belongs_to :admins, null: false, foreign_key: true
      t.belongs_to :admin_roles, null: false, foreign_key: true
      t.belongs_to :super_partners, null: true, foreign_key: true
      t.belongs_to :partners, null: true, foreign_key: true
      t.boolean :delete_flg, default:  false

      t.timestamps
    end
  end
end
