require "test_helper"

class Partner::PartnerUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_partner_user = partner_partner_users(:one)
  end

  test "should get index" do
    get partner_partner_users_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_partner_user_url
    assert_response :success
  end

  test "should create partner_partner_user" do
    assert_difference('Partner::PartnerUser.count') do
      post partner_partner_users_url, params: { partner_partner_user: {  } }
    end

    assert_redirected_to partner_partner_user_url(Partner::PartnerUser.last)
  end

  test "should show partner_partner_user" do
    get partner_partner_user_url(@partner_partner_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_partner_user_url(@partner_partner_user)
    assert_response :success
  end

  test "should update partner_partner_user" do
    patch partner_partner_user_url(@partner_partner_user), params: { partner_partner_user: {  } }
    assert_redirected_to partner_partner_user_url(@partner_partner_user)
  end

  test "should destroy partner_partner_user" do
    assert_difference('Partner::PartnerUser.count', -1) do
      delete partner_partner_user_url(@partner_partner_user)
    end

    assert_redirected_to partner_partner_users_url
  end
end
