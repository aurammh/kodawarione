require "application_system_test_case"

class Admin::ApiAccessTokensTest < ApplicationSystemTestCase
  setup do
    @admin_api_access_token = admin_api_access_tokens(:one)
  end

  test "visiting the index" do
    visit admin_api_access_tokens_url
    assert_selector "h1", text: "Admin/Api Access Tokens"
  end

  test "creating a Api access token" do
    visit admin_api_access_tokens_url
    click_on "New Admin/Api Access Token"

    click_on "Create Api access token"

    assert_text "Api access token was successfully created"
    click_on "Back"
  end

  test "updating a Api access token" do
    visit admin_api_access_tokens_url
    click_on "Edit", match: :first

    click_on "Update Api access token"

    assert_text "Api access token was successfully updated"
    click_on "Back"
  end

  test "destroying a Api access token" do
    visit admin_api_access_tokens_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Api access token was successfully destroyed"
  end
end
