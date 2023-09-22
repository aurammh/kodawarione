require "application_system_test_case"

class Partner::PartnerEventsTest < ApplicationSystemTestCase
  setup do
    @partner_partner_event = partner_partner_events(:one)
  end

  test "visiting the index" do
    visit partner_partner_events_url
    assert_selector "h1", text: "Partner/Partner Events"
  end

  test "creating a Partner event" do
    visit partner_partner_events_url
    click_on "New Partner/Partner Event"

    click_on "Create Partner event"

    assert_text "Partner event was successfully created"
    click_on "Back"
  end

  test "updating a Partner event" do
    visit partner_partner_events_url
    click_on "Edit", match: :first

    click_on "Update Partner event"

    assert_text "Partner event was successfully updated"
    click_on "Back"
  end

  test "destroying a Partner event" do
    visit partner_partner_events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Partner event was successfully destroyed"
  end
end
