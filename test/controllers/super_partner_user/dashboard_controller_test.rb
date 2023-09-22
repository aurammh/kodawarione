require "test_helper"

class SuperPartnerUser::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get super_partner_user_dashboard_index_url
    assert_response :success
  end
end
