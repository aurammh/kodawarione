require "application_system_test_case"

class SuperPartnerUser::NewsTest < ApplicationSystemTestCase
  setup do
    @super_partner_user_news = super_partner_user_news(:one)
  end

  test "visiting the index" do
    visit super_partner_user_news_url
    assert_selector "h1", text: "Super Partner User/News"
  end

  test "creating a News" do
    visit super_partner_user_news_url
    click_on "New Super Partner User/News"

    click_on "Create News"

    assert_text "News was successfully created"
    click_on "Back"
  end

  test "updating a News" do
    visit super_partner_user_news_url
    click_on "Edit", match: :first

    click_on "Update News"

    assert_text "News was successfully updated"
    click_on "Back"
  end

  test "destroying a News" do
    visit super_partner_user_news_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "News was successfully destroyed"
  end
end
