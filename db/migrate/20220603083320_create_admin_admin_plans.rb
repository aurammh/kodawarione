class CreateAdminAdminPlans < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_plans do |t|
      t.bigint :admin_id
      t.string :name, limit: 100
      t.text :content, limit: 1500
      t.bigint :fee
      t.timestamps
    end
  end
end
