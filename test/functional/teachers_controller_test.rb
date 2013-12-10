require 'test_helper'

class TeachersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    puts response.body
  end
end
