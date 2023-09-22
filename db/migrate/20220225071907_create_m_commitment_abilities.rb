class CreateMCommitmentAbilities < ActiveRecord::Migration[6.1]
  def change
    create_table :m_commitment_abilities do |t|
      t.string :name,comment: 'select the type of ability on screen'
      t.boolean :delete_flag ,:default => 'false', comment: ' default = false, deleted = true'
      t.timestamps
    end
  end
end
