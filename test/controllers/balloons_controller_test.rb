require "test_helper"

class BalloonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @balloon = balloons(:one)
  end

  test "should get index" do
    get balloons_url
    assert_response :success
  end

  test "should get new" do
    get new_balloon_url
    assert_response :success
  end

  test "should create balloon" do
    assert_difference("Balloon.count") do
      post balloons_url, params: { balloon: {  } }
    end

    assert_redirected_to balloon_url(Balloon.last)
  end

  test "should show balloon" do
    get balloon_url(@balloon)
    assert_response :success
  end

  test "should get edit" do
    get edit_balloon_url(@balloon)
    assert_response :success
  end

  test "should update balloon" do
    patch balloon_url(@balloon), params: { balloon: {  } }
    assert_redirected_to balloon_url(@balloon)
  end

  test "should destroy balloon" do
    assert_difference("Balloon.count", -1) do
      delete balloon_url(@balloon)
    end

    assert_redirected_to balloons_url
  end
end
