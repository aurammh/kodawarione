require "test_helper"

class Company::AdminEventParticipantControllerTest < ActionDispatch::IntegrationTest
  test "should get admin_event_participant" do
    get company_admin_event_participant_admin_event_participant_url
    assert_response :success
  end
end
