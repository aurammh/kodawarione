class CreateAdminNews < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_news do |t|
      t.string :title
      t.integer :news_type
      t.string :other
      t.boolean :delete_flg, default: false
      t.bigint :created_admin_id
      t.bigint :updated_admin_id
      t.timestamps
    end
  end
end
