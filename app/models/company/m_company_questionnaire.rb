class Company::MCompanyQuestionnaire < ApplicationRecord
    has_many :questionnaire_answers, class_name: "QuestionnaireAnswer"
end
