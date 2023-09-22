require "application_system_test_case"

class SuperPartnerUser::ArticlesTest < ApplicationSystemTestCase
  setup do
    @super_partner_user_article = super_partner_user_articles(:one)
  end

  test "visiting the index" do
    visit super_partner_user_articles_url
    assert_selector "h1", text: "Super Partner User/Articles"
  end

  test "creating a Article" do
    visit super_partner_user_articles_url
    click_on "New Super Partner User/Article"

    click_on "Create Article"

    assert_text "Article was successfully created"
    click_on "Back"
  end

  test "updating a Article" do
    visit super_partner_user_articles_url
    click_on "Edit", match: :first

    click_on "Update Article"

    assert_text "Article was successfully updated"
    click_on "Back"
  end

  test "destroying a Article" do
    visit super_partner_user_articles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Article was successfully destroyed"
  end
end
