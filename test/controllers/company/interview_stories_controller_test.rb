require "test_helper"

class Company::InterviewStoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_interview_story = company_interview_stories(:one)
  end

  test "should get index" do
    get company_interview_stories_url
    assert_response :success
  end

  test "should get new" do
    get new_company_interview_story_url
    assert_response :success
  end

  test "should create company_interview_story" do
    assert_difference('Company::InterviewStory.count') do
      post company_interview_stories_url, params: { company_interview_story: { review: @company_interview_story.review, title: @company_interview_story.title } }
    end

    assert_redirected_to company_interview_story_url(Company::InterviewStory.last)
  end

  test "should show company_interview_story" do
    get company_interview_story_url(@company_interview_story)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_interview_story_url(@company_interview_story)
    assert_response :success
  end

  test "should update company_interview_story" do
    patch company_interview_story_url(@company_interview_story), params: { company_interview_story: { review: @company_interview_story.review, title: @company_interview_story.title } }
    assert_redirected_to company_interview_story_url(@company_interview_story)
  end

  test "should destroy company_interview_story" do
    assert_difference('Company::InterviewStory.count', -1) do
      delete company_interview_story_url(@company_interview_story)
    end

    assert_redirected_to company_interview_stories_url
  end
end
