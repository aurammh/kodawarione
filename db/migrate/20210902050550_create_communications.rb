class CreateCommunications < ActiveRecord::Migration[6.1]
  def change
    create_table :communications do |t|
      t.string :title
      t.string :category
      t.integer :sender_id
      t.integer :receiver_id
      t.string :content
      t.integer :mail_type
      t.integer :sent_type
      t.integer :user_id
      t.integer :company_user_id
      t.bigint :company_id
      t.integer :scout_status
      t.datetime :scout_date
      t.bigint :vacancy_id
      t.timestamps
    end
  end
end
