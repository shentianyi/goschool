#encoding: utf-8
class StudentCourseObserver<ActiveRecord::Observer
  observe :student_course
  def after_create student_course
    student_course.course.increment!(:actual_number)
    if student=student_course.student
      student.update_attributes(:student_status=>StudentStatus::READING,:course_number=>student.course_number+1)
    end
  end

  def after_destroy student_course
    student_course.course.decrement!(:actual_number)
    if student=student_course.student
      if student.course_number==1
        student.update_attributes(:student_status=>StudentStatus::PORENTIAL,:course_number=>student.course_number-1)
      elsif student.course_number>1
        student.decrement!(:course_number)
      end
    end
  end
end
