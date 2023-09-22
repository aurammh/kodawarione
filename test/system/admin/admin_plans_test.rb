require "application_system_test_case"

class Admin::AdminPlansTest < ApplicationSystemTestCase
  setup do
    @admin_admin_plan = admin_admin_plans(:one)
  end

  test "visiting the index" do
    visit admin_admin_plans_url
    assert_selector "h1", text: "Admin/Admin Plans"
  end

  test "creating a Admin plan" do
    visit admin_admin_plans_url
    click_on "New Admin/Admin Plan"

    click_on "Create Admin plan"

    assert_text "Admin plan was successfully created"
    click_on "Back"
  end

  test "updating a Admin plan" do
    visit admin_admin_plans_url
    click_on "Edit", match: :first

    click_on "Update Admin plan"

    assert_text "Admin plan was successfully updated"
    click_on "Back"
  end

  test "destroying a Admin plan" do
    visit admin_admin_plans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Admin plan was successfully destroyed"
  end
end
