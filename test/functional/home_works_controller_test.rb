require 'test_helper'

class HomeWorksControllerTest < ActionController::TestCase
  setup do
    @home_work = home_works(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:home_works)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create home_work" do
    assert_difference('HomeWork.count') do
      post :create, home_work: { content: @home_work.content, deadline: @home_work.deadline, title: @home_work.title }
    end

    assert_redirected_to home_work_path(assigns(:home_work))
  end

  test "should show home_work" do
    get :show, id: @home_work
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @home_work
    assert_response :success
  end

  test "should update home_work" do
    put :update, id: @home_work, home_work: { content: @home_work.content, deadline: @home_work.deadline, title: @home_work.title }
    assert_redirected_to home_work_path(assigns(:home_work))
  end

  test "should destroy home_work" do
    assert_difference('HomeWork.count', -1) do
      delete :destroy, id: @home_work
    end

    assert_redirected_to home_works_path
  end
end
