class JoinMember::JoinMemberMailer < ApplicationMailer
  layout 'layouts/join_member/mailer'
  default from: 'noreply@kodawarione.com'

  def member_mails
    @company_company_member = params[:company_member_mails]
    @company_name = params[:company_name]
    mail(to: @company_company_member.user_email, subject: 'メンバー招待メール')
  end
end
