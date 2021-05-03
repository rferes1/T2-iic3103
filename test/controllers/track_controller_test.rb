require 'test_helper'

class TrackControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get track_new_url
    assert_response :success
  end

  test "should get index" do
    get track_index_url
    assert_response :success
  end

  test "should get show" do
    get track_show_url
    assert_response :success
  end

  test "should get edit" do
    get track_edit_url
    assert_response :success
  end

end
