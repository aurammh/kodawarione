require "test_helper"

class SuperPartnerUser::PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @super_partner_user_plan = super_partner_user_plans(:one)
  end

  test "should get index" do
    get super_partner_user_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_super_partner_user_plan_url
    assert_response :success
  end

  test "should create super_partner_user_plan" do
    assert_difference('SuperPartnerUser::Plan.count') do
      post super_partner_user_plans_url, params: { super_partner_user_plan: {  } }
    end

    assert_redirected_to super_partner_user_plan_url(SuperPartnerUser::Plan.last)
  end

  test "should show super_partner_user_plan" do
    get super_partner_user_plan_url(@super_partner_user_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_super_partner_user_plan_url(@super_partner_user_plan)
    assert_response :success
  end

  test "should update super_partner_user_plan" do
    patch super_partner_user_plan_url(@super_partner_user_plan), params: { super_partner_user_plan: {  } }
    assert_redirected_to super_partner_user_plan_url(@super_partner_user_plan)
  end

  test "should destroy super_partner_user_plan" do
    assert_difference('SuperPartnerUser::Plan.count', -1) do
      delete super_partner_user_plan_url(@super_partner_user_plan)
    end

    assert_redirected_to super_partner_user_plans_url
  end
end
