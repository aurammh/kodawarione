require "application_system_test_case"

class Admin::SuperPartnersTest < ApplicationSystemTestCase
  setup do
    @admin_super_partner = admin_super_partners(:one)
  end

  test "visiting the index" do
    visit admin_super_partners_url
    assert_selector "h1", text: "Admin/Super Partners"
  end

  test "creating a Super partner" do
    visit admin_super_partners_url
    click_on "New Admin/Super Partner"

    click_on "Create Super partner"

    assert_text "Super partner was successfully created"
    click_on "Back"
  end

  test "updating a Super partner" do
    visit admin_super_partners_url
    click_on "Edit", match: :first

    click_on "Update Super partner"

    assert_text "Super partner was successfully updated"
    click_on "Back"
  end

  test "destroying a Super partner" do
    visit admin_super_partners_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Super partner was successfully destroyed"
  end
end
