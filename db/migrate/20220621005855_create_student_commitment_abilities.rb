class CreateStudentCommitmentAbilities < ActiveRecord::Migration[6.1]
  def change
    create_table :student_commitment_abilities do |t|
      t.string :status      
      t.belongs_to :student, null: false, foreign_key: true    
      t.timestamps
    end    
  end
end