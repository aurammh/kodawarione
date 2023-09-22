class CreateStudentCompanyMatchedResults < ActiveRecord::Migration[6.1]
  def change
    create_table :student_company_matched_results do |t| 
      t.float :overall_result, null: false         
      t.float :ability_1_percentage, null: false 
      t.float :ability_2_percentage, null: false
      t.float :ability_3_percentage, null: false  
      t.string :company_status
      t.integer :student_id, null: false 
      t.integer :company_id, null: false 
      t.json :result_details
      t.boolean :delete_flg, null: false, default: false
      t.timestamps
    end
  end
end

