require "test_helper"

class SuperPartnerUser::ContractsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @super_partner_user_contract = super_partner_user_contracts(:one)
  end

  test "should get index" do
    get super_partner_user_contracts_url
    assert_response :success
  end

  test "should get new" do
    get new_super_partner_user_contract_url
    assert_response :success
  end

  test "should create super_partner_user_contract" do
    assert_difference('SuperPartnerUser::Contract.count') do
      post super_partner_user_contracts_url, params: { super_partner_user_contract: {  } }
    end

    assert_redirected_to super_partner_user_contract_url(SuperPartnerUser::Contract.last)
  end

  test "should show super_partner_user_contract" do
    get super_partner_user_contract_url(@super_partner_user_contract)
    assert_response :success
  end

  test "should get edit" do
    get edit_super_partner_user_contract_url(@super_partner_user_contract)
    assert_response :success
  end

  test "should update super_partner_user_contract" do
    patch super_partner_user_contract_url(@super_partner_user_contract), params: { super_partner_user_contract: {  } }
    assert_redirected_to super_partner_user_contract_url(@super_partner_user_contract)
  end

  test "should destroy super_partner_user_contract" do
    assert_difference('SuperPartnerUser::Contract.count', -1) do
      delete super_partner_user_contract_url(@super_partner_user_contract)
    end

    assert_redirected_to super_partner_user_contracts_url
  end
end
