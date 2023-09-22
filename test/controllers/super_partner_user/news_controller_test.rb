require "test_helper"

class SuperPartnerUser::NewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @super_partner_user_news = super_partner_user_news(:one)
  end

  test "should get index" do
    get super_partner_user_news_index_url
    assert_response :success
  end

  test "should get new" do
    get new_super_partner_user_news_url
    assert_response :success
  end

  test "should create super_partner_user_news" do
    assert_difference('SuperPartnerUser::News.count') do
      post super_partner_user_news_index_url, params: { super_partner_user_news: {  } }
    end

    assert_redirected_to super_partner_user_news_url(SuperPartnerUser::News.last)
  end

  test "should show super_partner_user_news" do
    get super_partner_user_news_url(@super_partner_user_news)
    assert_response :success
  end

  test "should get edit" do
    get edit_super_partner_user_news_url(@super_partner_user_news)
    assert_response :success
  end

  test "should update super_partner_user_news" do
    patch super_partner_user_news_url(@super_partner_user_news), params: { super_partner_user_news: {  } }
    assert_redirected_to super_partner_user_news_url(@super_partner_user_news)
  end

  test "should destroy super_partner_user_news" do
    assert_difference('SuperPartnerUser::News.count', -1) do
      delete super_partner_user_news_url(@super_partner_user_news)
    end

    assert_redirected_to super_partner_user_news_index_url
  end
end
