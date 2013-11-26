require 'test_helper'

class StudentCoursesControllerTest < ActionController::TestCase
  setup do
    @student_course = student_courses(:one)
  end

  test "should create student_course" do
    assert_difference('StudentCourse.count') do
      post :create, student_course: {course_id:courses(:one).id,student_id:students(:one).id  }
      puts response.body
    end
  end

  test "should pay student_course" do
    put :pay, id: @student_course,  paid:true 
    puts response.body
  end

  test "should destroy student_course" do
    assert_difference('StudentCourse.count', -1) do
      delete :destroy, id: @student_course
      puts response.body
    end
  end

  test "should creates student_courses" do
    assert_difference('StudentCourse.count') do
      post :creates,student_courses:[
        {student_course: {course_id:courses(:one).id,student_id:students(:one).id}},
        {student_course: {course_id:courses(:two).id,student_id:students(:two).id}},
        {student_course: {course_id:courses(:three).id,student_id:students(:two).id}}]
      puts response.body
    end
  end

  test "should pays student_courses" do
    put :pays, {ids:[student_courses(:one).id,student_courses(:two).id,33],paid:true}
    puts response.body
  end

  test "should destroies student_courses" do
    assert_difference('StudentCourse.count', -1) do
      delete :destroies, ids: [student_courses(:one).id,student_courses(:two).id,22]
      puts response.body
    end
  end
end
