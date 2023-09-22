require "test_helper"

class Partner::ContractsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_contract = partner_contracts(:one)
  end

  test "should get index" do
    get partner_contracts_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_contract_url
    assert_response :success
  end

  test "should create partner_contract" do
    assert_difference('Partner::Contract.count') do
      post partner_contracts_url, params: { partner_contract: {  } }
    end

    assert_redirected_to partner_contract_url(Partner::Contract.last)
  end

  test "should show partner_contract" do
    get partner_contract_url(@partner_contract)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_contract_url(@partner_contract)
    assert_response :success
  end

  test "should update partner_contract" do
    patch partner_contract_url(@partner_contract), params: { partner_contract: {  } }
    assert_redirected_to partner_contract_url(@partner_contract)
  end

  test "should destroy partner_contract" do
    assert_difference('Partner::Contract.count', -1) do
      delete partner_contract_url(@partner_contract)
    end

    assert_redirected_to partner_contracts_url
  end
end
