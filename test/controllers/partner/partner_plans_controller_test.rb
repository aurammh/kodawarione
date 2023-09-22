require "test_helper"

class Partner::PartnerPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_partner_plan = partner_partner_plans(:one)
  end

  test "should get index" do
    get partner_partner_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_partner_plan_url
    assert_response :success
  end

  test "should create partner_partner_plan" do
    assert_difference('Partner::PartnerPlan.count') do
      post partner_partner_plans_url, params: { partner_partner_plan: {  } }
    end

    assert_redirected_to partner_partner_plan_url(Partner::PartnerPlan.last)
  end

  test "should show partner_partner_plan" do
    get partner_partner_plan_url(@partner_partner_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_partner_plan_url(@partner_partner_plan)
    assert_response :success
  end

  test "should update partner_partner_plan" do
    patch partner_partner_plan_url(@partner_partner_plan), params: { partner_partner_plan: {  } }
    assert_redirected_to partner_partner_plan_url(@partner_partner_plan)
  end

  test "should destroy partner_partner_plan" do
    assert_difference('Partner::PartnerPlan.count', -1) do
      delete partner_partner_plan_url(@partner_partner_plan)
    end

    assert_redirected_to partner_partner_plans_url
  end
end
