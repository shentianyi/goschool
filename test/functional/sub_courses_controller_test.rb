require 'test_helper'

class SubCoursesControllerTest < ActionController::TestCase
  setup do
    @sub_course = sub_courses(:one)
  end
  test "should create sub_course" do
    assert_difference('SubCourse.count') do
      post :create, course_id:courses(:two).id,sub_course: { name:'Write' }
      puts response.body
    end

  end


  test "should update sub_course" do
    put :update, id: @sub_course, sub_course: { name: 'Jump'}
    puts response.body
  end

  test "should destroy sub_course" do
    assert_difference('SubCourse.count', -1) do
      delete :destroy, id: @sub_course
      puts response.body
    end

  end
end
