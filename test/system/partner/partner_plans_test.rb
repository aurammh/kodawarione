require "application_system_test_case"

class Partner::PartnerPlansTest < ApplicationSystemTestCase
  setup do
    @partner_partner_plan = partner_partner_plans(:one)
  end

  test "visiting the index" do
    visit partner_partner_plans_url
    assert_selector "h1", text: "Partner/Partner Plans"
  end

  test "creating a Partner plan" do
    visit partner_partner_plans_url
    click_on "New Partner/Partner Plan"

    click_on "Create Partner plan"

    assert_text "Partner plan was successfully created"
    click_on "Back"
  end

  test "updating a Partner plan" do
    visit partner_partner_plans_url
    click_on "Edit", match: :first

    click_on "Update Partner plan"

    assert_text "Partner plan was successfully updated"
    click_on "Back"
  end

  test "destroying a Partner plan" do
    visit partner_partner_plans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Partner plan was successfully destroyed"
  end
end
