class CreateMStudentQuestionnaires < ActiveRecord::Migration[6.1]
    def change
      create_table :m_student_questionnaires do |t|
        t.string :questionnaire_title, null: false
        t.string :questionnaire_content, null: false
        t.integer :basic_point
        t.integer :stages
        t.boolean :delete_flg, default: false, null: false
        t.timestamps
      end
    end
end
  