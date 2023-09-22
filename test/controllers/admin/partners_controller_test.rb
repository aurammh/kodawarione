require "test_helper"

class Admin::PartnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_partner = admin_partners(:one)
  end

  test "should get index" do
    get admin_partners_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_partner_url
    assert_response :success
  end

  test "should create admin_partner" do
    assert_difference('Admin::Partner.count') do
      post admin_partners_url, params: { admin_partner: {  } }
    end

    assert_redirected_to admin_partner_url(Admin::Partner.last)
  end

  test "should show admin_partner" do
    get admin_partner_url(@admin_partner)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_partner_url(@admin_partner)
    assert_response :success
  end

  test "should update admin_partner" do
    patch admin_partner_url(@admin_partner), params: { admin_partner: {  } }
    assert_redirected_to admin_partner_url(@admin_partner)
  end

  test "should destroy admin_partner" do
    assert_difference('Admin::Partner.count', -1) do
      delete admin_partner_url(@admin_partner)
    end

    assert_redirected_to admin_partners_url
  end
end
