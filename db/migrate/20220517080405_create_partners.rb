class CreatePartners < ActiveRecord::Migration[6.1]
  def change
    create_table :partners do |t|
      t.string :name, limit: 255
      t.string :partner_code, limit: 10
      t.bigint :super_partner_id
      t.string :postal_code, limit: 10
      t.string :address, limit: 255
      t.string :display_address, limit: 255
      t.string :phone_no, limit: 20
      t.string :website_url, limit: 255
      t.string :postalcode_city
      t.bigint :m_region_id
      t.bigint :m_prefecture_id
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
