require "test_helper"

class Partner::CompanyManage::EventControllerTest < ActionDispatch::IntegrationTest
  test "should get event_search" do
    get partner_company_manage_event_event_search_url
    assert_response :success
  end
end
