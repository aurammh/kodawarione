class CreateCompanyMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :company_members do |t|
      t.belongs_to :user
      t.string :user_email
      t.bigint :company_id
      t.bigint :company_roles_id
      t.bigint :created_userid
      t.bigint :updated_userid
      t.boolean :join_flag, :default => 'false', comment: ' default = false, joined = true'
      t.date :join_date
      t.string :confirmation_token
      t.string :department    
      t.string :position 
      t.timestamps
    end
  end
end
