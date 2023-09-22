require "test_helper"

class Admin::SuperPartnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_super_partner = admin_super_partners(:one)
  end

  test "should get index" do
    get admin_super_partners_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_super_partner_url
    assert_response :success
  end

  test "should create admin_super_partner" do
    assert_difference('Admin::SuperPartner.count') do
      post admin_super_partners_url, params: { admin_super_partner: {  } }
    end

    assert_redirected_to admin_super_partner_url(Admin::SuperPartner.last)
  end

  test "should show admin_super_partner" do
    get admin_super_partner_url(@admin_super_partner)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_super_partner_url(@admin_super_partner)
    assert_response :success
  end

  test "should update admin_super_partner" do
    patch admin_super_partner_url(@admin_super_partner), params: { admin_super_partner: {  } }
    assert_redirected_to admin_super_partner_url(@admin_super_partner)
  end

  test "should destroy admin_super_partner" do
    assert_difference('Admin::SuperPartner.count', -1) do
      delete admin_super_partner_url(@admin_super_partner)
    end

    assert_redirected_to admin_super_partners_url
  end
end
