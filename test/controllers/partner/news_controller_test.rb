require "test_helper"

class Partner::NewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_news = partner_news(:one)
  end

  test "should get index" do
    get partner_news_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_news_url
    assert_response :success
  end

  test "should create partner_news" do
    assert_difference('Partner::New.count') do
      post partner_news_url, params: { partner_news: {  } }
    end

    assert_redirected_to partner_news_url(Partner::New.last)
  end

  test "should show partner_news" do
    get partner_news_url(@partner_news)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_news_url(@partner_news)
    assert_response :success
  end

  test "should update partner_news" do
    patch partner_news_url(@partner_news), params: { partner_news: {  } }
    assert_redirected_to partner_news_url(@partner_news)
  end

  test "should destroy partner_news" do
    assert_difference('Partner::New.count', -1) do
      delete partner_news_url(@partner_news)
    end

    assert_redirected_to partner_news_url
  end
end
