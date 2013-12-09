require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users(:one)
    @tenant = tenants(:one)
  end

  test "should get index" do
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
      post :create, user: {name:'Dorcy',email:'dorcy@dorcy.com'},
      logininfo: {email:'dorcy@dorcy.com',password:'1111',password_confirmation:'1111',tenant_id:@tenant,status:'1'},
      logininfo_roles:[100,200]
    end
  end

  test "should get edit" do
    get :edit, id:@user
    assert_response :success
  end

  test "should update user" do
    put :update, id:@user, user:{name:@user.name,email:@user.email}
  #assert_redirected_to user_path(assigns(:user))
  end

  # test "should destroy user" do
    # assert_difference('User.count', -1) do
      # delete :destroy, id:@user
    # end
    # assert_redirected_to users_path
  # end

  test "should get  user courses" do
    get :teacher,id:@user.id
    assert_response :success
    puts response.body
  end

end
