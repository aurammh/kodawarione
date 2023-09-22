require "test_helper"

class Admin::PartnerUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_partner_user = admin_partner_users(:one)
  end

  test "should get index" do
    get admin_partner_users_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_partner_user_url
    assert_response :success
  end

  test "should create admin_partner_user" do
    assert_difference('Admin::PartnerUser.count') do
      post admin_partner_users_url, params: { admin_partner_user: {  } }
    end

    assert_redirected_to admin_partner_user_url(Admin::PartnerUser.last)
  end

  test "should show admin_partner_user" do
    get admin_partner_user_url(@admin_partner_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_partner_user_url(@admin_partner_user)
    assert_response :success
  end

  test "should update admin_partner_user" do
    patch admin_partner_user_url(@admin_partner_user), params: { admin_partner_user: {  } }
    assert_redirected_to admin_partner_user_url(@admin_partner_user)
  end

  test "should destroy admin_partner_user" do
    assert_difference('Admin::PartnerUser.count', -1) do
      delete admin_partner_user_url(@admin_partner_user)
    end

    assert_redirected_to admin_partner_users_url
  end
end
