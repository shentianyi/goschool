require 'test_helper'

class SubCoursesControllerTest < ActionController::TestCase
  setup do
    @sub_course = sub_courses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sub_courses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sub_course" do
    assert_difference('SubCourse.count') do
      post :create, sub_course: { name: @sub_course.name, parent_name: @sub_course.parent_name }
    end

    assert_redirected_to sub_course_path(assigns(:sub_course))
  end

  test "should show sub_course" do
    get :show, id: @sub_course
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sub_course
    assert_response :success
  end

  test "should update sub_course" do
    put :update, id: @sub_course, sub_course: { name: @sub_course.name, parent_name: @sub_course.parent_name }
    assert_redirected_to sub_course_path(assigns(:sub_course))
  end

  test "should destroy sub_course" do
    assert_difference('SubCourse.count', -1) do
      delete :destroy, id: @sub_course
    end

    assert_redirected_to sub_courses_path
  end
end
