require "test_helper"

class Kodawarione::PlansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kodawarione_plans_index_url
    assert_response :success
  end
end
