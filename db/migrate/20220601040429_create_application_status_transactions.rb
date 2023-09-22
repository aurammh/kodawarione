class CreateApplicationStatusTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :application_status_transactions do |t|
      t.belongs_to :student
      t.belongs_to :company
      t.belongs_to :partner
      t.belongs_to :company_vacancy
      t.belongs_to :communication
      t.integer :status
      t.datetime :interview_date
      t.string :interview_result
      t.timestamps
    end
  end
end
