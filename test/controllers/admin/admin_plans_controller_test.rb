require "test_helper"

class Admin::AdminPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_admin_plan = admin_admin_plans(:one)
  end

  test "should get index" do
    get admin_admin_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_admin_plan_url
    assert_response :success
  end

  test "should create admin_admin_plan" do
    assert_difference('Admin::AdminPlan.count') do
      post admin_admin_plans_url, params: { admin_admin_plan: {  } }
    end

    assert_redirected_to admin_admin_plan_url(Admin::AdminPlan.last)
  end

  test "should show admin_admin_plan" do
    get admin_admin_plan_url(@admin_admin_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_admin_plan_url(@admin_admin_plan)
    assert_response :success
  end

  test "should update admin_admin_plan" do
    patch admin_admin_plan_url(@admin_admin_plan), params: { admin_admin_plan: {  } }
    assert_redirected_to admin_admin_plan_url(@admin_admin_plan)
  end

  test "should destroy admin_admin_plan" do
    assert_difference('Admin::AdminPlan.count', -1) do
      delete admin_admin_plan_url(@admin_admin_plan)
    end

    assert_redirected_to admin_admin_plans_url
  end
end
