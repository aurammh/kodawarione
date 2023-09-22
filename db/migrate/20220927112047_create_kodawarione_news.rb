class CreateKodawarioneNews < ActiveRecord::Migration[6.1]
  def change
    create_table :news do |t|
      t.string :title
      t.integer :news_type, comment: 'admin=1, super_partner=2, partner=3'
      t.bigint :created_by_id, comment: 'admin_id, super_partner_id, partner_id'
      t.integer :news_category, comment: ', other=1, important=2, usually=3'
      t.string :other
      t.integer :show_option, array: true, using: "ARRAY[show_option]::INTEGER[]", comment: 'super_partner=1, partner=2, company=3, student=4'
      t.bigint :created_user_id
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
