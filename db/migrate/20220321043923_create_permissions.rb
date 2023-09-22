class CreatePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :permissions do |t|
      t.string :permission_name
      t.string :action_name
      t.string :permission_model_name
      t.integer :permission_for
      t.boolean :permission_default_can
      t.string :permission_group
      t.string :remark
      t.timestamps
    end
  end
end
