class CreateCompanyRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :company_roles do |t|
      t.belongs_to :company
      t.string :role_type
      t.string :remark
      t.bigint :created_user_id
      t.bigint :updated_user_id
      t.timestamps
    end
  end
end