require "test_helper"

class Kodawarione::SuperPartnerManage::SuperPartnerManageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kodawarione_super_partner_manage_super_partner_manage_index_url
    assert_response :success
  end
end
