module Communication::MailTemplateRegistrationsHelper
    def mail_template_options
        Communication::MailTemplateRegistration.where(:company_id => current_company.id).order(created_at: :desc)
    end
end
