require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "show update setting" do
    put :update,:id=>1,:setting=>{:default_pwd=>"jack"}
    assert_response :success
    puts response.body
  end
end
