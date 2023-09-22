require "test_helper"

class CompanyPageControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get company_page_home_url
    assert_response :success
  end
end
