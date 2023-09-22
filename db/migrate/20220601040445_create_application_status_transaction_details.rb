class CreateApplicationStatusTransactionDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :application_status_transaction_details do |t|
      t.belongs_to :application_status_transaction, index: { name: :application_status }
      t.integer :type_id
      t.integer :status
      t.integer :updated_user_role
      t.integer :updated_user_id
      t.timestamps
    end
  end
end
