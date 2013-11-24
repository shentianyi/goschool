require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should update setting" do
    put :update,:id=>1,:setting=>{:default_pwd=>""}
    assert_response :success
    puts response.body
  end
end
