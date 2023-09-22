class Communication::MailTemplateRegistration < ApplicationRecord
    self.table_name = "mail_template_registrations"

    has_rich_text :content
    has_one :action_text_rich_text,class_name: 'ActionText::RichText',as: :record

    validates :template_name, presence: true, on: [:create, :update]
    validates :subject, presence: true, on: [:create, :update]
    validates :content, presence: true, on: [:create, :update]
end
