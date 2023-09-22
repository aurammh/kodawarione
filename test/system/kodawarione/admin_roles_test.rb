require "application_system_test_case"

class Kodawarione::AdminRolesTest < ApplicationSystemTestCase
  setup do
    @kodawarione_admin_role = kodawarione_admin_roles(:one)
  end

  test "visiting the index" do
    visit kodawarione_admin_roles_url
    assert_selector "h1", text: "Kodawarione/Admin Roles"
  end

  test "creating a Admin role" do
    visit kodawarione_admin_roles_url
    click_on "New Kodawarione/Admin Role"

    check "Delete flg" if @kodawarione_admin_role.delete_flg
    fill_in "Role type", with: @kodawarione_admin_role.role_type
    click_on "Create Admin role"

    assert_text "Admin role was successfully created"
    click_on "Back"
  end

  test "updating a Admin role" do
    visit kodawarione_admin_roles_url
    click_on "Edit", match: :first

    check "Delete flg" if @kodawarione_admin_role.delete_flg
    fill_in "Role type", with: @kodawarione_admin_role.role_type
    click_on "Update Admin role"

    assert_text "Admin role was successfully updated"
    click_on "Back"
  end

  test "destroying a Admin role" do
    visit kodawarione_admin_roles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Admin role was successfully destroyed"
  end
end
