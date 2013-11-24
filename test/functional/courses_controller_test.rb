require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    @course = courses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

 
  test "should create course" do
    assert_difference('Course.count') do
      post :create, course: { actual_number: @course.actual_number, description: @course.description, end_date: @course.end_date, expect_number: @course.expect_number, lesson: @course.lesson, name: @course.name, start_date: @course.start_date, sub_number: @course.sub_number, type: @course.type }
    end

  end

  test "should show course" do
    get :show, id: @course
    assert_response :success
  end

  

  test "should update course" do
    put :update, id: @course, course: { actual_number: @course.actual_number, description: @course.description, end_date: @course.end_date, expect_number: @course.expect_number, lesson: @course.lesson, name: @course.name, start_date: @course.start_date, sub_number: @course.sub_number, type: @course.type }
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete :destroy, id: @course
    end
  end
end
