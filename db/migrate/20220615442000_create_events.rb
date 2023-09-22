class CreateEvents < ActiveRecord::Migration[6.1]
    def change
      create_table :events do |t|           
        t.string :event_code
        t.bigint :created_by_id, comment:'company_id, partner_id and admin_id'
        t.string :event_name
        t.integer :venue_types
        t.string :venue
        t.integer :category, array: true, using: "ARRAY[category]::INTEGER[]"
        t.integer :event_show_option   
        t.integer :apply_event_limit     
        t.bigint :created_user_id
        t.integer :event_type, comment: ' company=1, partner=2, admin=3 , super_partner=4'
        t.date :event_start_date
        t.date :event_end_date        
        t.date :post_start_date
        t.date :post_end_date
        t.date :application_start_date
        t.date :application_deadline      
        t.boolean :delete_flg, default: false
        t.timestamps
      end
    end
end
  