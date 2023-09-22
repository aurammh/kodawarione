require "test_helper"

class Partner::PartnerEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_partner_event = partner_partner_events(:one)
  end

  test "should get index" do
    get partner_partner_events_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_partner_event_url
    assert_response :success
  end

  test "should create partner_partner_event" do
    assert_difference('Partner::PartnerEvent.count') do
      post partner_partner_events_url, params: { partner_partner_event: {  } }
    end

    assert_redirected_to partner_partner_event_url(Partner::PartnerEvent.last)
  end

  test "should show partner_partner_event" do
    get partner_partner_event_url(@partner_partner_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_partner_event_url(@partner_partner_event)
    assert_response :success
  end

  test "should update partner_partner_event" do
    patch partner_partner_event_url(@partner_partner_event), params: { partner_partner_event: {  } }
    assert_redirected_to partner_partner_event_url(@partner_partner_event)
  end

  test "should destroy partner_partner_event" do
    assert_difference('Partner::PartnerEvent.count', -1) do
      delete partner_partner_event_url(@partner_partner_event)
    end

    assert_redirected_to partner_partner_events_url
  end
end
