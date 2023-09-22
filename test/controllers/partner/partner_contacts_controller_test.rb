require "test_helper"

class Partner::PartnerContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_partner_contact = partner_partner_contacts(:one)
  end

  test "should get index" do
    get partner_partner_contacts_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_partner_contact_url
    assert_response :success
  end

  test "should create partner_partner_contact" do
    assert_difference('Partner::PartnerContact.count') do
      post partner_partner_contacts_url, params: { partner_partner_contact: {  } }
    end

    assert_redirected_to partner_partner_contact_url(Partner::PartnerContact.last)
  end

  test "should show partner_partner_contact" do
    get partner_partner_contact_url(@partner_partner_contact)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_partner_contact_url(@partner_partner_contact)
    assert_response :success
  end

  test "should update partner_partner_contact" do
    patch partner_partner_contact_url(@partner_partner_contact), params: { partner_partner_contact: {  } }
    assert_redirected_to partner_partner_contact_url(@partner_partner_contact)
  end

  test "should destroy partner_partner_contact" do
    assert_difference('Partner::PartnerContact.count', -1) do
      delete partner_partner_contact_url(@partner_partner_contact)
    end

    assert_redirected_to partner_partner_contacts_url
  end
end
