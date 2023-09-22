class Welcome::CompanyConfirmMailer < ApplicationMailer
    layout 'layouts/mailer/company_confirm_mailer'
    default from: 'noreply@kodawarione.com'

    def company_confirm_email
        @email = params[:email]
        @company_user = params[:company_users]
        @company_name = params[:company_name]
        mail(to: @email, subject: 'KODAWARI ONE 登録完了のお知らせ')
    end

end