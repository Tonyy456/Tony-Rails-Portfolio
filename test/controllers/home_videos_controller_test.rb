require "test_helper"

class HomeVideosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @home_video = home_videos(:one)
  end

  test "should get index" do
    get home_videos_url
    assert_response :success
  end

  test "should get new" do
    get new_home_video_url
    assert_response :success
  end

  test "should create home_video" do
    assert_difference("HomeVideo.count") do
      post home_videos_url, params: { home_video: {  } }
    end

    assert_redirected_to home_video_url(HomeVideo.last)
  end

  test "should show home_video" do
    get home_video_url(@home_video)
    assert_response :success
  end

  test "should get edit" do
    get edit_home_video_url(@home_video)
    assert_response :success
  end

  test "should update home_video" do
    patch home_video_url(@home_video), params: { home_video: {  } }
    assert_redirected_to home_video_url(@home_video)
  end

  test "should destroy home_video" do
    assert_difference("HomeVideo.count", -1) do
      delete home_video_url(@home_video)
    end

    assert_redirected_to home_videos_url
  end
end
