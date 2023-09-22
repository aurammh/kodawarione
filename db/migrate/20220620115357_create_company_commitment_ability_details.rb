class CreateCompanyCommitmentAbilityDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :company_commitment_ability_details do |t|           
      t.integer :ability_value
      t.string :ability_reason        
      t.belongs_to :m_commitment_abilities, null: false, foreign_key: true, index: { name: :company_commitment_ability_id }   
      t.belongs_to :company, null: false, foreign_key: true   
      t.belongs_to :company_commitment_ability, null: false, foreign_key: true, index: { name: :company_commitment_ability }      
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
