class CreateAssessmentMatchedResults < ActiveRecord::Migration[6.1]
  def change
    create_table :assessment_matched_results do |t|
      t.belongs_to :student, null: false, foreign_key: true
      t.belongs_to :company, null: false, foreign_key: true
      t.string :role
      t.float :matched_result, null: false 
      t.timestamps
    end
  end
end
