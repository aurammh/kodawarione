require "test_helper"

class Kodawarione::PartnerManage::PartnerManageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kodawarione_partner_manage_partner_manage_index_url
    assert_response :success
  end
end
