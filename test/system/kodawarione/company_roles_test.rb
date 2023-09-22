require "application_system_test_case"

class Kodawarione::CompanyRolesTest < ApplicationSystemTestCase
  setup do
    @kodawarione_company_role = kodawarione_company_roles(:one)
  end

  test "visiting the index" do
    visit kodawarione_company_roles_url
    assert_selector "h1", text: "Kodawarione/Company Roles"
  end

  test "creating a Company role" do
    visit kodawarione_company_roles_url
    click_on "New Kodawarione/Company Role"

    click_on "Create Company role"

    assert_text "Company role was successfully created"
    click_on "Back"
  end

  test "updating a Company role" do
    visit kodawarione_company_roles_url
    click_on "Edit", match: :first

    click_on "Update Company role"

    assert_text "Company role was successfully updated"
    click_on "Back"
  end

  test "destroying a Company role" do
    visit kodawarione_company_roles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Company role was successfully destroyed"
  end
end
