require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user:{name:'test', email:'1@1.com', logininfo:{email:'1@1.com', password:'111111', password_confirmation:'111111'},status:'0'}
    end
    assert_redirected_to user_path(assign(:user))
  end
end
