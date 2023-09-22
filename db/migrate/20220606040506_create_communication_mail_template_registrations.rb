class CreateCommunicationMailTemplateRegistrations < ActiveRecord::Migration[6.1]
  def change
    create_table :mail_template_registrations do |t|
      t.belongs_to :company
      t.string :template_name 
      t.string :subject
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
