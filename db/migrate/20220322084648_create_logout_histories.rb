class CreateLogoutHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :logout_histories do |t|
      t.belongs_to :company_user
      t.bigint :company_id
      t.integer :active_type 
      t.timestamps
    end
  end
end
