require "application_system_test_case"

class Company::InterviewStoriesTest < ApplicationSystemTestCase
  setup do
    @company_interview_story = company_interview_stories(:one)
  end

  test "visiting the index" do
    visit company_interview_stories_url
    assert_selector "h1", text: "Company/Interview Stories"
  end

  test "creating a Interview story" do
    visit company_interview_stories_url
    click_on "New Company/Interview Story"

    fill_in "Review", with: @company_interview_story.review
    fill_in "Title", with: @company_interview_story.title
    click_on "Create Interview story"

    assert_text "Interview story was successfully created"
    click_on "Back"
  end

  test "updating a Interview story" do
    visit company_interview_stories_url
    click_on "Edit", match: :first

    fill_in "Review", with: @company_interview_story.review
    fill_in "Title", with: @company_interview_story.title
    click_on "Update Interview story"

    assert_text "Interview story was successfully updated"
    click_on "Back"
  end

  test "destroying a Interview story" do
    visit company_interview_stories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Interview story was successfully destroyed"
  end
end
