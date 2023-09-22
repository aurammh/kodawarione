require "application_system_test_case"

class Company::CompanyMembersTest < ApplicationSystemTestCase
  setup do
    @company_company_member = company_company_members(:one)
  end

  test "visiting the index" do
    visit company_company_members_url
    assert_selector "h1", text: "Company/Company Members"
  end

  test "creating a Company member" do
    visit company_company_members_url
    click_on "New Company/Company Member"

    click_on "Create Company member"

    assert_text "Company member was successfully created"
    click_on "Back"
  end

  test "updating a Company member" do
    visit company_company_members_url
    click_on "Edit", match: :first

    click_on "Update Company member"

    assert_text "Company member was successfully updated"
    click_on "Back"
  end

  test "destroying a Company member" do
    visit company_company_members_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Company member was successfully destroyed"
  end
end
