#encoding: utf-8
class SubCourseObserver<ActiveRecord::Observer
  observe :sub_course

  def after_create sub_course
     sub_course.course.sub_courses.where(:is_default=>true).destroy_all unless sub_course.is_default
     sub_course.course.update_attributes(:has_sub=>true) unless sub_course.is_default
  end

  def after_destroy sub_course
     course=sub_course.course
    if course.sub_courses.count==0
      course.update_attributes(:has_sub=>false)
      course.create_default_sub_course
    end
  end
end
