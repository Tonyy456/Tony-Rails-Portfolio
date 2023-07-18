require "test_helper"

class RunsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @run = runs(:one)
  end

  test "should get index" do
    get runs_url
    assert_response :success
  end

  test "should get new" do
    get new_run_url
    assert_response :success
  end

  test "should create run" do
    assert_difference("Run.count") do
      post runs_url, params: { run: { date: @run.date, distance: @run.distance, time: @run.time } }
    end

    assert_redirected_to run_url(Run.last)
  end

  test "should show run" do
    get run_url(@run)
    assert_response :success
  end

  test "should get edit" do
    get edit_run_url(@run)
    assert_response :success
  end

  test "should update run" do
    patch run_url(@run), params: { run: { date: @run.date, distance: @run.distance, time: @run.time } }
    assert_redirected_to run_url(@run)
  end

  test "should destroy run" do
    assert_difference("Run.count", -1) do
      delete run_url(@run)
    end

    assert_redirected_to runs_url
  end
end