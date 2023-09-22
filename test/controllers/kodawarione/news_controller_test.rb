require "test_helper"

class Kodawarione::NewsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kodawarione_news_index_url
    assert_response :success
  end
end
