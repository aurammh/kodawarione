class CreateCompanyActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :company_activities do |t|
      t.string :title
      t.belongs_to :company, null: false
      t.boolean :delete_flg

      t.timestamps
    end
  end
end
