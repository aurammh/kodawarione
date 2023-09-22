require "test_helper"

class SuperPartnerUser::SuperPartnerUserControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get super_partner_user_super_partner_user_index_url
    assert_response :success
  end

  test "should get show" do
    get super_partner_user_super_partner_user_show_url
    assert_response :success
  end

  test "should get new" do
    get super_partner_user_super_partner_user_new_url
    assert_response :success
  end
end
