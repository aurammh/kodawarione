class Welcome::ContactUsMailer < ApplicationMailer
    layout 'layouts/mailer/mailer'

    default to: -> {'support@kodawarione.com'},
          from: 'noreply@kodawarione.com'
    def contact_email
        @contact_us = params[:contact]
        mail(subject: 'お問い合わせメール')
    end

end