require "test_helper"

class Partner::CompanyManage::CompanyControllerTest < ActionDispatch::IntegrationTest
  test "should get company_search" do
    get partner_company_manage_company_company_search_url
    assert_response :success
  end
end
