require "test_helper"

class SuperPartnerUser::ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @super_partner_user_article = super_partner_user_articles(:one)
  end

  test "should get index" do
    get super_partner_user_articles_url
    assert_response :success
  end

  test "should get new" do
    get new_super_partner_user_article_url
    assert_response :success
  end

  test "should create super_partner_user_article" do
    assert_difference('SuperPartnerUser::Article.count') do
      post super_partner_user_articles_url, params: { super_partner_user_article: {  } }
    end

    assert_redirected_to super_partner_user_article_url(SuperPartnerUser::Article.last)
  end

  test "should show super_partner_user_article" do
    get super_partner_user_article_url(@super_partner_user_article)
    assert_response :success
  end

  test "should get edit" do
    get edit_super_partner_user_article_url(@super_partner_user_article)
    assert_response :success
  end

  test "should update super_partner_user_article" do
    patch super_partner_user_article_url(@super_partner_user_article), params: { super_partner_user_article: {  } }
    assert_redirected_to super_partner_user_article_url(@super_partner_user_article)
  end

  test "should destroy super_partner_user_article" do
    assert_difference('SuperPartnerUser::Article.count', -1) do
      delete super_partner_user_article_url(@super_partner_user_article)
    end

    assert_redirected_to super_partner_user_articles_url
  end
end
