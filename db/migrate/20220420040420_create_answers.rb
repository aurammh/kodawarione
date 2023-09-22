class CreateAnswers < ActiveRecord::Migration[6.1]
    def change
        create_table :answers do |t|
            t.integer :user_id, null: false
            t.integer :questionnaire_id, null: false
            t.integer :answer_id, null: false         
            t.string :comment
            t.string :role
            t.boolean :choice_flg, null: false
            t.boolean :delete_flg, default: false, null: false
            t.timestamps
        end
    end
end
  