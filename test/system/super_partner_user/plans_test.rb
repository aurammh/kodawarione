require "application_system_test_case"

class SuperPartnerUser::PlansTest < ApplicationSystemTestCase
  setup do
    @super_partner_user_plan = super_partner_user_plans(:one)
  end

  test "visiting the index" do
    visit super_partner_user_plans_url
    assert_selector "h1", text: "Super Partner User/Plans"
  end

  test "creating a Plan" do
    visit super_partner_user_plans_url
    click_on "New Super Partner User/Plan"

    click_on "Create Plan"

    assert_text "Plan was successfully created"
    click_on "Back"
  end

  test "updating a Plan" do
    visit super_partner_user_plans_url
    click_on "Edit", match: :first

    click_on "Update Plan"

    assert_text "Plan was successfully updated"
    click_on "Back"
  end

  test "destroying a Plan" do
    visit super_partner_user_plans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Plan was successfully destroyed"
  end
end
