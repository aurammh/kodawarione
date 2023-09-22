class CreateQuestionnaireAnswers < ActiveRecord::Migration[6.1]
    def change
        create_table :questionnaire_answers do |t|
            t.integer :questionnaire_id, null: false
            t.string :questionnaire_answer, null: false
            t.boolean :delete_flg, default: false, null: false
            t.timestamps
        end
    end
end