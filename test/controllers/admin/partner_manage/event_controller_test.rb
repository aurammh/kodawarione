require "test_helper"

class Admin::PartnerManage::EventControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_partner_manage_event_index_url
    assert_response :success
  end
end
