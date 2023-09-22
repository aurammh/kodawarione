require "test_helper"

class Kodawarione::AdminRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @kodawarione_admin_role = kodawarione_admin_roles(:one)
  end

  test "should get index" do
    get kodawarione_admin_roles_url
    assert_response :success
  end

  test "should get new" do
    get new_kodawarione_admin_role_url
    assert_response :success
  end

  test "should create kodawarione_admin_role" do
    assert_difference('Kodawarione::AdminRole.count') do
      post kodawarione_admin_roles_url, params: { kodawarione_admin_role: { delete_flg: @kodawarione_admin_role.delete_flg, role_type: @kodawarione_admin_role.role_type } }
    end

    assert_redirected_to kodawarione_admin_role_url(Kodawarione::AdminRole.last)
  end

  test "should show kodawarione_admin_role" do
    get kodawarione_admin_role_url(@kodawarione_admin_role)
    assert_response :success
  end

  test "should get edit" do
    get edit_kodawarione_admin_role_url(@kodawarione_admin_role)
    assert_response :success
  end

  test "should update kodawarione_admin_role" do
    patch kodawarione_admin_role_url(@kodawarione_admin_role), params: { kodawarione_admin_role: { delete_flg: @kodawarione_admin_role.delete_flg, role_type: @kodawarione_admin_role.role_type } }
    assert_redirected_to kodawarione_admin_role_url(@kodawarione_admin_role)
  end

  test "should destroy kodawarione_admin_role" do
    assert_difference('Kodawarione::AdminRole.count', -1) do
      delete kodawarione_admin_role_url(@kodawarione_admin_role)
    end

    assert_redirected_to kodawarione_admin_roles_url
  end
end
