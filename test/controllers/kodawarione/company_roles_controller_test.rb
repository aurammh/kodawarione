require "test_helper"

class Kodawarione::CompanyRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @kodawarione_company_role = kodawarione_company_roles(:one)
  end

  test "should get index" do
    get kodawarione_company_roles_url
    assert_response :success
  end

  test "should get new" do
    get new_kodawarione_company_role_url
    assert_response :success
  end

  test "should create kodawarione_company_role" do
    assert_difference('Kodawarione::CompanyRole.count') do
      post kodawarione_company_roles_url, params: { kodawarione_company_role: {  } }
    end

    assert_redirected_to kodawarione_company_role_url(Kodawarione::CompanyRole.last)
  end

  test "should show kodawarione_company_role" do
    get kodawarione_company_role_url(@kodawarione_company_role)
    assert_response :success
  end

  test "should get edit" do
    get edit_kodawarione_company_role_url(@kodawarione_company_role)
    assert_response :success
  end

  test "should update kodawarione_company_role" do
    patch kodawarione_company_role_url(@kodawarione_company_role), params: { kodawarione_company_role: {  } }
    assert_redirected_to kodawarione_company_role_url(@kodawarione_company_role)
  end

  test "should destroy kodawarione_company_role" do
    assert_difference('Kodawarione::CompanyRole.count', -1) do
      delete kodawarione_company_role_url(@kodawarione_company_role)
    end

    assert_redirected_to kodawarione_company_roles_url
  end
end
