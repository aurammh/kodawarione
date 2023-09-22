require "application_system_test_case"

class Admin::AdminContractsTest < ApplicationSystemTestCase
  setup do
    @admin_admin_contract = admin_admin_contracts(:one)
  end

  test "visiting the index" do
    visit admin_admin_contracts_url
    assert_selector "h1", text: "Admin/Admin Contracts"
  end

  test "creating a Admin contract" do
    visit admin_admin_contracts_url
    click_on "New Admin/Admin Contract"

    click_on "Create Admin contract"

    assert_text "Admin contract was successfully created"
    click_on "Back"
  end

  test "updating a Admin contract" do
    visit admin_admin_contracts_url
    click_on "Edit", match: :first

    click_on "Update Admin contract"

    assert_text "Admin contract was successfully updated"
    click_on "Back"
  end

  test "destroying a Admin contract" do
    visit admin_admin_contracts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Admin contract was successfully destroyed"
  end
end
