#encoding: utf-8
class CourseObserver<ActiveRecord::Observer
  observe :course
  def after_create course
    course.create_default_sub_course
  end
end
