require "application_system_test_case"

class SuperPartnerUser::ContractsTest < ApplicationSystemTestCase
  setup do
    @super_partner_user_contract = super_partner_user_contracts(:one)
  end

  test "visiting the index" do
    visit super_partner_user_contracts_url
    assert_selector "h1", text: "Super Partner User/Contracts"
  end

  test "creating a Contract" do
    visit super_partner_user_contracts_url
    click_on "New Super Partner User/Contract"

    click_on "Create Contract"

    assert_text "Contract was successfully created"
    click_on "Back"
  end

  test "updating a Contract" do
    visit super_partner_user_contracts_url
    click_on "Edit", match: :first

    click_on "Update Contract"

    assert_text "Contract was successfully updated"
    click_on "Back"
  end

  test "destroying a Contract" do
    visit super_partner_user_contracts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Contract was successfully destroyed"
  end
end
