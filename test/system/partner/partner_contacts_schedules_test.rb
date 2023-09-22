require "application_system_test_case"

class Partner::PartnerContactsSchedulesTest < ApplicationSystemTestCase
  setup do
    @partner_partner_contacts_schedule = partner_partner_contacts_schedules(:one)
  end

  test "visiting the index" do
    visit partner_partner_contacts_schedules_url
    assert_selector "h1", text: "Partner/Partner Contacts Schedules"
  end

  test "creating a Partner contacts schedule" do
    visit partner_partner_contacts_schedules_url
    click_on "New Partner/Partner Contacts Schedule"

    click_on "Create Partner contacts schedule"

    assert_text "Partner contacts schedule was successfully created"
    click_on "Back"
  end

  test "updating a Partner contacts schedule" do
    visit partner_partner_contacts_schedules_url
    click_on "Edit", match: :first

    click_on "Update Partner contacts schedule"

    assert_text "Partner contacts schedule was successfully updated"
    click_on "Back"
  end

  test "destroying a Partner contacts schedule" do
    visit partner_partner_contacts_schedules_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Partner contacts schedule was successfully destroyed"
  end
end
