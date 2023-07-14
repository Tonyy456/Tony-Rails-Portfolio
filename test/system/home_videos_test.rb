require "application_system_test_case"

class HomeVideosTest < ApplicationSystemTestCase
  setup do
    @home_video = home_videos(:one)
  end

  test "visiting the index" do
    visit home_videos_url
    assert_selector "h1", text: "Home videos"
  end

  test "should create home video" do
    visit home_videos_url
    click_on "New home video"

    click_on "Create Home video"

    assert_text "Home video was successfully created"
    click_on "Back"
  end

  test "should update Home video" do
    visit home_video_url(@home_video)
    click_on "Edit this home video", match: :first

    click_on "Update Home video"

    assert_text "Home video was successfully updated"
    click_on "Back"
  end

  test "should destroy Home video" do
    visit home_video_url(@home_video)
    click_on "Destroy this home video", match: :first

    assert_text "Home video was successfully destroyed"
  end
end
