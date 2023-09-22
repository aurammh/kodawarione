require "application_system_test_case"

class Partner::ContractsTest < ApplicationSystemTestCase
  setup do
    @partner_contract = partner_contracts(:one)
  end

  test "visiting the index" do
    visit partner_contracts_url
    assert_selector "h1", text: "Partner/Contracts"
  end

  test "creating a Contract" do
    visit partner_contracts_url
    click_on "New Partner/Contract"

    click_on "Create Contract"

    assert_text "Contract was successfully created"
    click_on "Back"
  end

  test "updating a Contract" do
    visit partner_contracts_url
    click_on "Edit", match: :first

    click_on "Update Contract"

    assert_text "Contract was successfully updated"
    click_on "Back"
  end

  test "destroying a Contract" do
    visit partner_contracts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Contract was successfully destroyed"
  end
end
