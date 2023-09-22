require "test_helper"

class Kodawarione::ContractsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kodawarione_contracts_index_url
    assert_response :success
  end
end
