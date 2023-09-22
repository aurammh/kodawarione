require "test_helper"

class Partner::ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_article = partner_articles(:one)
  end

  test "should get index" do
    get partner_articles_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_article_url
    assert_response :success
  end

  test "should create partner_article" do
    assert_difference('Partner::Article.count') do
      post partner_articles_url, params: { partner_article: {  } }
    end

    assert_redirected_to partner_article_url(Partner::Article.last)
  end

  test "should show partner_article" do
    get partner_article_url(@partner_article)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_article_url(@partner_article)
    assert_response :success
  end

  test "should update partner_article" do
    patch partner_article_url(@partner_article), params: { partner_article: {  } }
    assert_redirected_to partner_article_url(@partner_article)
  end

  test "should destroy partner_article" do
    assert_difference('Partner::Article.count', -1) do
      delete partner_article_url(@partner_article)
    end

    assert_redirected_to partner_articles_url
  end
end
