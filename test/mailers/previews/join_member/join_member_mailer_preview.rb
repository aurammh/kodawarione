# Preview all emails at http://localhost:3000/rails/mailers/join_member/join_member_mailer
class JoinMember::JoinMemberMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/join_member/join_member_mailer/member_mails
  def member_mails
    JoinMember::JoinMemberMailer.member_mails
  end

end
