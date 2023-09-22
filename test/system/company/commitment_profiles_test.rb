require "application_system_test_case"

class Company::CommitmentProfilesTest < ApplicationSystemTestCase
  setup do
    @company_commitment_profile = company_commitment_profiles(:one)
  end

  test "visiting the index" do
    visit company_commitment_profiles_url
    assert_selector "h1", text: "Company/Commitment Profiles"
  end

  test "creating a Commitment profile" do
    visit company_commitment_profiles_url
    click_on "New Company/Commitment Profile"

    fill_in "Company message", with: @company_commitment_profile.company_message
    fill_in "Created userid", with: @company_commitment_profile.created_userid
    fill_in "Experience requirements", with: @company_commitment_profile.experience_requirements
    fill_in "Fresher requirements", with: @company_commitment_profile.fresher_requirements
    fill_in "Fresher second requirements", with: @company_commitment_profile.fresher_second_requirements
    fill_in "Other message", with: @company_commitment_profile.other_message
    fill_in "Title 1", with: @company_commitment_profile.title_1
    fill_in "Title 2", with: @company_commitment_profile.title_2
    fill_in "Title 3", with: @company_commitment_profile.title_3
    fill_in "Updated userid", with: @company_commitment_profile.updated_userid
    click_on "Create Commitment profile"

    assert_text "Commitment profile was successfully created"
    click_on "Back"
  end

  test "updating a Commitment profile" do
    visit company_commitment_profiles_url
    click_on "Edit", match: :first

    fill_in "Company message", with: @company_commitment_profile.company_message
    fill_in "Created userid", with: @company_commitment_profile.created_userid
    fill_in "Experience requirements", with: @company_commitment_profile.experience_requirements
    fill_in "Fresher requirements", with: @company_commitment_profile.fresher_requirements
    fill_in "Fresher second requirements", with: @company_commitment_profile.fresher_second_requirements
    fill_in "Other message", with: @company_commitment_profile.other_message
    fill_in "Title 1", with: @company_commitment_profile.title_1
    fill_in "Title 2", with: @company_commitment_profile.title_2
    fill_in "Title 3", with: @company_commitment_profile.title_3
    fill_in "Updated userid", with: @company_commitment_profile.updated_userid
    click_on "Update Commitment profile"

    assert_text "Commitment profile was successfully updated"
    click_on "Back"
  end

  test "destroying a Commitment profile" do
    visit company_commitment_profiles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Commitment profile was successfully destroyed"
  end
end
