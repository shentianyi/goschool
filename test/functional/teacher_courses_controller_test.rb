require 'test_helper'

class TeacherCoursesControllerTest < ActionController::TestCase
  setup do
    @teacher_course = teacher_courses(:one)
  end
 
  test "should create teacher_course" do
    assert_difference('TeacherCourse.count') do
      post :create, teacher_course: {sub_course_id:sub_courses(:one).id,user_id:users(:one)  }
      puts response.body
    end
 
  end
 
  test "should update teacher_course" do
    put :update, id: @teacher_course, teacher_course: {sub_course_id:sub_courses(:two),user_id:users(:one)  }
    puts response.body
  end

  test "should destroy teacher_course" do
    assert_difference('TeacherCourse.count', -1) do
      delete :destroy, id: @teacher_course
      puts response.body
    end
 
  end
end
