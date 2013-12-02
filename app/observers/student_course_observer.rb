#encoding: utf-8
class StudentCourseObserver<ActiveRecord::Observer
  observe :student_course

  def after_create student_course
    student_course.course.increment!(:actual_number)
    student_course.student.update_attributes(:student_status=>StudentStatus::READING)
  end

  def after_destroy student_course
     student_course.course.decrement!(:actual_number)
     if (student=student_course.student) && student.courses.count==0
       student.update_attributes(:student_status=>StudentStatus::PORENTIAL)
     end 
   end
end
