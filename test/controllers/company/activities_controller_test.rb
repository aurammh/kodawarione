require "test_helper"

class Company::ActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_activity = company_activities(:one)
  end

  test "should get index" do
    get company_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_company_activity_url
    assert_response :success
  end

  test "should create company_activity" do
    assert_difference('Company::Activity.count') do
      post company_activities_url, params: { company_activity: { company_id: @company_activity.company_id, delete_flg: @company_activity.delete_flg, title: @company_activity.title } }
    end

    assert_redirected_to company_activity_url(Company::Activity.last)
  end

  test "should show company_activity" do
    get company_activity_url(@company_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_activity_url(@company_activity)
    assert_response :success
  end

  test "should update company_activity" do
    patch company_activity_url(@company_activity), params: { company_activity: { company_id: @company_activity.company_id, delete_flg: @company_activity.delete_flg, title: @company_activity.title } }
    assert_redirected_to company_activity_url(@company_activity)
  end

  test "should destroy company_activity" do
    assert_difference('Company::Activity.count', -1) do
      delete company_activity_url(@company_activity)
    end

    assert_redirected_to company_activities_url
  end
end
