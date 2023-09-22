class CreateAdminArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_articles do |t|
      t.string :title
      t.string :video_link, array: true
      t.integer :show_option
      t.boolean :delete_flg, default: false
      t.bigint :created_admin_id
      t.bigint :updated_admin_id
      t.timestamps
    end
  end
end
