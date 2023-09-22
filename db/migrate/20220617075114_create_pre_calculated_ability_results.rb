class CreatePreCalculatedAbilityResults < ActiveRecord::Migration[6.1]
  def change
    create_table :pre_calculated_ability_results do |t|
      t.integer :ability_1_id
      t.integer :ability_2_id
      t.float :matched_percentage
      t.float :original_matched_result
      t.boolean :delete_flg, default: false
      t.timestamps
    end
  end
end
