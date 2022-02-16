require "application_system_test_case"

class BalloonsTest < ApplicationSystemTestCase
  setup do
    @balloon = balloons(:one)
  end

  test "visiting the index" do
    visit balloons_url
    assert_selector "h1", text: "Balloons"
  end

  test "should create balloon" do
    visit balloons_url
    click_on "New balloon"

    click_on "Create Balloon"

    assert_text "Balloon was successfully created"
    click_on "Back"
  end

  test "should update Balloon" do
    visit balloon_url(@balloon)
    click_on "Edit this balloon", match: :first

    click_on "Update Balloon"

    assert_text "Balloon was successfully updated"
    click_on "Back"
  end

  test "should destroy Balloon" do
    visit balloon_url(@balloon)
    click_on "Destroy this balloon", match: :first

    assert_text "Balloon was successfully destroyed"
  end
end
