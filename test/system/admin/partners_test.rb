require "application_system_test_case"

class Admin::PartnersTest < ApplicationSystemTestCase
  setup do
    @admin_partner = admin_partners(:one)
  end

  test "visiting the index" do
    visit admin_partners_url
    assert_selector "h1", text: "Admin/Partners"
  end

  test "creating a Partner" do
    visit admin_partners_url
    click_on "New Admin/Partner"

    click_on "Create Partner"

    assert_text "Partner was successfully created"
    click_on "Back"
  end

  test "updating a Partner" do
    visit admin_partners_url
    click_on "Edit", match: :first

    click_on "Update Partner"

    assert_text "Partner was successfully updated"
    click_on "Back"
  end

  test "destroying a Partner" do
    visit admin_partners_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Partner was successfully destroyed"
  end
end
