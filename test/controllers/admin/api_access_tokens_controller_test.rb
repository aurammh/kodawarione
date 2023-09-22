require "test_helper"

class Admin::ApiAccessTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_api_access_token = admin_api_access_tokens(:one)
  end

  test "should get index" do
    get admin_api_access_tokens_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_api_access_token_url
    assert_response :success
  end

  test "should create admin_api_access_token" do
    assert_difference('Admin::ApiAccessToken.count') do
      post admin_api_access_tokens_url, params: { admin_api_access_token: {  } }
    end

    assert_redirected_to admin_api_access_token_url(Admin::ApiAccessToken.last)
  end

  test "should show admin_api_access_token" do
    get admin_api_access_token_url(@admin_api_access_token)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_api_access_token_url(@admin_api_access_token)
    assert_response :success
  end

  test "should update admin_api_access_token" do
    patch admin_api_access_token_url(@admin_api_access_token), params: { admin_api_access_token: {  } }
    assert_redirected_to admin_api_access_token_url(@admin_api_access_token)
  end

  test "should destroy admin_api_access_token" do
    assert_difference('Admin::ApiAccessToken.count', -1) do
      delete admin_api_access_token_url(@admin_api_access_token)
    end

    assert_redirected_to admin_api_access_tokens_url
  end
end
