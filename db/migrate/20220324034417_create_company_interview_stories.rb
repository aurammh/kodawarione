class CreateCompanyInterviewStories < ActiveRecord::Migration[6.1]
  def change
    create_table :company_interview_stories do |t|
      t.belongs_to :user
      t.belongs_to :company
      t.string :title, limit: 200
      t.text :review, limit: 255

      t.timestamps
    end
  end
end
