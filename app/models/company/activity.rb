class Company::Activity < ApplicationRecord
  self.table_name = "company_activities"
  belongs_to :company

  has_one_attached :video_clip
  has_one_attached :thumbnail
  has_rich_text :desc
  has_one :action_text_rich_text,class_name: 'ActionText::RichText',as: :record

  validates :title, presence: true
  validates :desc, length: { maximum: 1000 }
  # validates :thumbnail, presence: true
  # validates :video_clip, presence: true
end
