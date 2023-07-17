require "application_system_test_case"

class RunsTest < ApplicationSystemTestCase
  setup do
    @run = runs(:one)
  end

  test "visiting the index" do
    visit runs_url
    assert_selector "h1", text: "Runs"
  end

  test "should create run" do
    visit runs_url
    click_on "New run"

    fill_in "Date", with: @run.date
    fill_in "Distance", with: @run.distance
    fill_in "Time", with: @run.time
    click_on "Create Run"

    assert_text "Run was successfully created"
    click_on "Back"
  end

  test "should update Run" do
    visit run_url(@run)
    click_on "Edit this run", match: :first

    fill_in "Date", with: @run.date
    fill_in "Distance", with: @run.distance
    fill_in "Time", with: @run.time
    click_on "Update Run"

    assert_text "Run was successfully updated"
    click_on "Back"
  end

  test "should destroy Run" do
    visit run_url(@run)
    click_on "Destroy this run", match: :first

    assert_text "Run was successfully destroyed"
  end
end
