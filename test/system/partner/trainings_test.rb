require "application_system_test_case"

class Partner::TrainingsTest < ApplicationSystemTestCase
  setup do
    @partner_training = partner_trainings(:one)
  end

  test "visiting the index" do
    visit partner_trainings_url
    assert_selector "h1", text: "Partner/Trainings"
  end

  test "creating a Training" do
    visit partner_trainings_url
    click_on "New Partner/Training"

    click_on "Create Training"

    assert_text "Training was successfully created"
    click_on "Back"
  end

  test "updating a Training" do
    visit partner_trainings_url
    click_on "Edit", match: :first

    click_on "Update Training"

    assert_text "Training was successfully updated"
    click_on "Back"
  end

  test "destroying a Training" do
    visit partner_trainings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Training was successfully destroyed"
  end
end
