require "application_system_test_case"

class Partner::PartnerContactsTest < ApplicationSystemTestCase
  setup do
    @partner_partner_contact = partner_partner_contacts(:one)
  end

  test "visiting the index" do
    visit partner_partner_contacts_url
    assert_selector "h1", text: "Partner/Partner Contacts"
  end

  test "creating a Partner contact" do
    visit partner_partner_contacts_url
    click_on "New Partner/Partner Contact"

    click_on "Create Partner contact"

    assert_text "Partner contact was successfully created"
    click_on "Back"
  end

  test "updating a Partner contact" do
    visit partner_partner_contacts_url
    click_on "Edit", match: :first

    click_on "Update Partner contact"

    assert_text "Partner contact was successfully updated"
    click_on "Back"
  end

  test "destroying a Partner contact" do
    visit partner_partner_contacts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Partner contact was successfully destroyed"
  end
end
