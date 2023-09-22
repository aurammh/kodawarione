require "test_helper"

class Company::CompanyMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_company_member = company_company_members(:one)
  end

  test "should get index" do
    get company_company_members_url
    assert_response :success
  end

  test "should get new" do
    get new_company_company_member_url
    assert_response :success
  end

  test "should create company_company_member" do
    assert_difference('Company::CompanyMember.count') do
      post company_company_members_url, params: { company_company_member: {  } }
    end

    assert_redirected_to company_company_member_url(Company::CompanyMember.last)
  end

  test "should show company_company_member" do
    get company_company_member_url(@company_company_member)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_company_member_url(@company_company_member)
    assert_response :success
  end

  test "should update company_company_member" do
    patch company_company_member_url(@company_company_member), params: { company_company_member: {  } }
    assert_redirected_to company_company_member_url(@company_company_member)
  end

  test "should destroy company_company_member" do
    assert_difference('Company::CompanyMember.count', -1) do
      delete company_company_member_url(@company_company_member)
    end

    assert_redirected_to company_company_members_url
  end
end
