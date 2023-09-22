require "test_helper"

class Admin::AdminContractsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_admin_contract = admin_admin_contracts(:one)
  end

  test "should get index" do
    get admin_admin_contracts_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_admin_contract_url
    assert_response :success
  end

  test "should create admin_admin_contract" do
    assert_difference('Admin::AdminContract.count') do
      post admin_admin_contracts_url, params: { admin_admin_contract: {  } }
    end

    assert_redirected_to admin_admin_contract_url(Admin::AdminContract.last)
  end

  test "should show admin_admin_contract" do
    get admin_admin_contract_url(@admin_admin_contract)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_admin_contract_url(@admin_admin_contract)
    assert_response :success
  end

  test "should update admin_admin_contract" do
    patch admin_admin_contract_url(@admin_admin_contract), params: { admin_admin_contract: {  } }
    assert_redirected_to admin_admin_contract_url(@admin_admin_contract)
  end

  test "should destroy admin_admin_contract" do
    assert_difference('Admin::AdminContract.count', -1) do
      delete admin_admin_contract_url(@admin_admin_contract)
    end

    assert_redirected_to admin_admin_contracts_url
  end
end
