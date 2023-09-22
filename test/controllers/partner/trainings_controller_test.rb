require "test_helper"

class Partner::TrainingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_training = partner_trainings(:one)
  end

  test "should get index" do
    get partner_trainings_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_training_url
    assert_response :success
  end

  test "should create partner_training" do
    assert_difference('Partner::Training.count') do
      post partner_trainings_url, params: { partner_training: {  } }
    end

    assert_redirected_to partner_training_url(Partner::Training.last)
  end

  test "should show partner_training" do
    get partner_training_url(@partner_training)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_training_url(@partner_training)
    assert_response :success
  end

  test "should update partner_training" do
    patch partner_training_url(@partner_training), params: { partner_training: {  } }
    assert_redirected_to partner_training_url(@partner_training)
  end

  test "should destroy partner_training" do
    assert_difference('Partner::Training.count', -1) do
      delete partner_training_url(@partner_training)
    end

    assert_redirected_to partner_trainings_url
  end
end
