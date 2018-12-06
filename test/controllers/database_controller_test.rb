require 'test_helper'

class DatabaseControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get index_path
    assert_response :success
    assert_includes @response.headers['Content-type'], 'text/html'
  end

  test "should get output" do
    get output_path max: 0
    assert_response :success
    assert_includes @response.headers['Content-type'], 'text/html'
  end

  test "should get correct output" do
    get output_path max: nil
    assert_response :success
    assert_nil assigns[:count]

    get output_path max: 'some_str'
    assert_response :success
    assert_nil assigns[:count]

    get output_path max: -1
    assert_response :success
    assert_nil assigns[:count]

    get output_path(max: 3)
    assert_response :success
    assert_equal 1, assigns[:count]

    get output_path(max: 10)
    assert_response :success
    assert_equal 4, assigns[:count]

    get output_path(max: 180)
    assert_response :success
    assert_equal 4, assigns[:count]
  end
end
