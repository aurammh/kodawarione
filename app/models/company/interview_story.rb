class Company::InterviewStory < ApplicationRecord
    belongs_to :company, class_name: "Company::Company"
    belongs_to :user, foreign_key: "user_id",optional: true
    has_rich_text :review
    has_one_attached :image
    self.table_name = "company_interview_stories"
    validates :title, length: { maximum: 200 }, presence: true
    validates :review, length: { maximum: 1000 }, presence: true
end
