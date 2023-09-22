require "test_helper"

class Partner::SuperPartnerEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get partner_super_partner_events_index_url
    assert_response :success
  end
end
