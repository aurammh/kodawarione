class CreateApiAccessToken < ActiveRecord::Migration[6.1]
  def change
    create_table :api_access_tokens do |t|
      t.string :token_type
      t.string :token
      t.string :name
      t.integer :token_scope , array: true, using: "ARRAY[token_scope]::INTEGER[]"
      t.string :ip_address
      t.boolean :delete_flg, default: false
      t.bigint :created_admin_id
      t.bigint :updated_admin_id
      t.timestamp :last_used_at
      t.timestamps
    end
  end
end
