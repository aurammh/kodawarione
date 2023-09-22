require "test_helper"

class Company::CommitmentProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_commitment_profile = company_commitment_profiles(:one)
  end

  test "should get index" do
    get company_commitment_profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_company_commitment_profile_url
    assert_response :success
  end

  test "should create company_commitment_profile" do
    assert_difference('Company::CommitmentProfile.count') do
      post company_commitment_profiles_url, params: { company_commitment_profile: { company_message: @company_commitment_profile.company_message, created_userid: @company_commitment_profile.created_userid, experience_requirements: @company_commitment_profile.experience_requirements, fresher_requirements: @company_commitment_profile.fresher_requirements, fresher_second_requirements: @company_commitment_profile.fresher_second_requirements, other_message: @company_commitment_profile.other_message, title_1: @company_commitment_profile.title_1, title_2: @company_commitment_profile.title_2, title_3: @company_commitment_profile.title_3, updated_userid: @company_commitment_profile.updated_userid } }
    end

    assert_redirected_to company_commitment_profile_url(Company::CommitmentProfile.last)
  end

  test "should show company_commitment_profile" do
    get company_commitment_profile_url(@company_commitment_profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_commitment_profile_url(@company_commitment_profile)
    assert_response :success
  end

  test "should update company_commitment_profile" do
    patch company_commitment_profile_url(@company_commitment_profile), params: { company_commitment_profile: { company_message: @company_commitment_profile.company_message, created_userid: @company_commitment_profile.created_userid, experience_requirements: @company_commitment_profile.experience_requirements, fresher_requirements: @company_commitment_profile.fresher_requirements, fresher_second_requirements: @company_commitment_profile.fresher_second_requirements, other_message: @company_commitment_profile.other_message, title_1: @company_commitment_profile.title_1, title_2: @company_commitment_profile.title_2, title_3: @company_commitment_profile.title_3, updated_userid: @company_commitment_profile.updated_userid } }
    assert_redirected_to company_commitment_profile_url(@company_commitment_profile)
  end

  test "should destroy company_commitment_profile" do
    assert_difference('Company::CommitmentProfile.count', -1) do
      delete company_commitment_profile_url(@company_commitment_profile)
    end

    assert_redirected_to company_commitment_profiles_url
  end
end
