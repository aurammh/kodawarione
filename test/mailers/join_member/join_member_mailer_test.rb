require "test_helper"

class JoinMember::JoinMemberMailerTest < ActionMailer::TestCase
  test "member_mails" do
    mail = JoinMember::JoinMemberMailer.member_mails
    assert_equal "Member mails", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
