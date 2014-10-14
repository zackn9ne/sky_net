require 'test_helper'

class WeatherControllerTest < ActionController::TestCase
  test "should get current_temp" do
    get :current_temp
    assert_response :success
  end

  test "should get forecast" do
    get :forecast
    assert_response :success
  end

  test "should get location" do
    get :location
    assert_response :success
  end

end
