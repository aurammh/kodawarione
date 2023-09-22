require "application_system_test_case"

class Partner::PartnerUsersTest < ApplicationSystemTestCase
  setup do
    @partner_partner_user = partner_partner_users(:one)
  end

  test "visiting the index" do
    visit partner_partner_users_url
    assert_selector "h1", text: "Partner/Partner Users"
  end

  test "creating a Partner user" do
    visit partner_partner_users_url
    click_on "New Partner/Partner User"

    click_on "Create Partner user"

    assert_text "Partner user was successfully created"
    click_on "Back"
  end

  test "updating a Partner user" do
    visit partner_partner_users_url
    click_on "Edit", match: :first

    click_on "Update Partner user"

    assert_text "Partner user was successfully updated"
    click_on "Back"
  end

  test "destroying a Partner user" do
    visit partner_partner_users_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Partner user was successfully destroyed"
  end
end
