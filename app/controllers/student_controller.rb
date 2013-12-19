class StudentController < ApplicationController
  skip_before_filter :require_user_as_employee
  before_filter :require_user_as_student
  layout 'homepage'
  
  def index
    @student = current_user.student
    @courses = CoursePresenter.init_presenters(Student.course_detail @student.id)
  end
end
