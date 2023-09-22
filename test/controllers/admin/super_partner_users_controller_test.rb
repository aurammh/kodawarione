require "test_helper"

class Admin::SuperPartnerUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_super_partner_users_index_url
    assert_response :success
  end
end
