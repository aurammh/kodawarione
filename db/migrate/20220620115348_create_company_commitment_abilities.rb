class CreateCompanyCommitmentAbilities < ActiveRecord::Migration[6.1]
  def change
    create_table :company_commitment_abilities do |t|
      t.string :status      
      t.belongs_to :company, null: false, foreign_key: true    
      t.timestamps
    end
  end
end

