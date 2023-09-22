require "application_system_test_case"

class Company::ActivitiesTest < ApplicationSystemTestCase
  setup do
    @company_activity = company_activities(:one)
  end

  test "visiting the index" do
    visit company_activities_url
    assert_selector "h1", text: "Company/Activities"
  end

  test "creating a Activity" do
    visit company_activities_url
    click_on "New Company/Activity"

    fill_in "Company", with: @company_activity.company_id
    check "Delete flg" if @company_activity.delete_flg
    fill_in "Title", with: @company_activity.title
    click_on "Create Activity"

    assert_text "Activity was successfully created"
    click_on "Back"
  end

  test "updating a Activity" do
    visit company_activities_url
    click_on "Edit", match: :first

    fill_in "Company", with: @company_activity.company_id
    check "Delete flg" if @company_activity.delete_flg
    fill_in "Title", with: @company_activity.title
    click_on "Update Activity"

    assert_text "Activity was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity" do
    visit company_activities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity was successfully destroyed"
  end
end
