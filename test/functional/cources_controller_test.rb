require 'test_helper'

class CourcesControllerTest < ActionController::TestCase
  setup do
    @cource = cources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cource" do
    assert_difference('Cource.count') do
      post :create, cource: { actual_number: @cource.actual_number, description: @cource.description, end_date: @cource.end_date, expect_number: @cource.expect_number, lesson: @cource.lesson, name: @cource.name, start_date: @cource.start_date, sub_number: @cource.sub_number, type: @cource.type }
    end

    assert_redirected_to cource_path(assigns(:cource))
  end

  test "should show cource" do
    get :show, id: @cource
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cource
    assert_response :success
  end

  test "should update cource" do
    put :update, id: @cource, cource: { actual_number: @cource.actual_number, description: @cource.description, end_date: @cource.end_date, expect_number: @cource.expect_number, lesson: @cource.lesson, name: @cource.name, start_date: @cource.start_date, sub_number: @cource.sub_number, type: @cource.type }
    assert_redirected_to cource_path(assigns(:cource))
  end

  test "should destroy cource" do
    assert_difference('Cource.count', -1) do
      delete :destroy, id: @cource
    end

    assert_redirected_to cources_path
  end
end
