require "test_helper"

class Partner::PartnerContactsSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_partner_contacts_schedule = partner_partner_contacts_schedules(:one)
  end

  test "should get index" do
    get partner_partner_contacts_schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_partner_contacts_schedule_url
    assert_response :success
  end

  test "should create partner_partner_contacts_schedule" do
    assert_difference('Partner::PartnerContactsSchedule.count') do
      post partner_partner_contacts_schedules_url, params: { partner_partner_contacts_schedule: {  } }
    end

    assert_redirected_to partner_partner_contacts_schedule_url(Partner::PartnerContactsSchedule.last)
  end

  test "should show partner_partner_contacts_schedule" do
    get partner_partner_contacts_schedule_url(@partner_partner_contacts_schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_partner_contacts_schedule_url(@partner_partner_contacts_schedule)
    assert_response :success
  end

  test "should update partner_partner_contacts_schedule" do
    patch partner_partner_contacts_schedule_url(@partner_partner_contacts_schedule), params: { partner_partner_contacts_schedule: {  } }
    assert_redirected_to partner_partner_contacts_schedule_url(@partner_partner_contacts_schedule)
  end

  test "should destroy partner_partner_contacts_schedule" do
    assert_difference('Partner::PartnerContactsSchedule.count', -1) do
      delete partner_partner_contacts_schedule_url(@partner_partner_contacts_schedule)
    end

    assert_redirected_to partner_partner_contacts_schedules_url
  end
end
