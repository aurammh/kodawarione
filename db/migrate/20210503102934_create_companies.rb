class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.bigint :partner_id
      t.string :company_name, limit: 255
      t.string :company_name_kana, limit: 255
      t.string :postal_code, limit: 10
      t.string :address, limit: 255
      t.string :display_address, limit: 255
      t.string :phone_no, limit: 20
      t.string :website_url, limit: 255
      t.bigint :m_industry_id
      t.bigint :m_region_id
      t.bigint :m_prefecture_id
      t.string :postalcode_city
      t.date   :company_established
      t.string :capital_amount
      t.bigint :employee_count
      t.string :sales_amount
      t.text   :related_company, limit: 1000
      t.text   :main_bank, limit: 1000
      t.string :representative
      t.text :contact, limit: 1000
      t.text   :history, limit: 1000
      t.string :transportation_facilities
      t.text   :basic_idea, limit: 1000
      t.integer :mail_setting,default: 0
      t.string :contact_email,null: false, default: ""
      t.bigint :created_user_id
      t.bigint :updated_user_id
      t.json :progress_details
      t.boolean :progress_complete
      t.boolean :delete_flg, default: false 
      t.timestamps
    end
  end
end
