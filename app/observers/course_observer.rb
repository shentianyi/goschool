#encoding: utf-8
class CourseObserver<ActiveRecord::Observer
  observe :course
  def after_save course
    TagService.add_tags(course)
  end

  def before_create course
    course.subs.each do |sub|
      sub_course=SubCourse.new(:name=>sub[:name],:parent_name=>course.name,:institution_id=>course.institution_id)
      sub_course.assign_teachers(sub[:teachers]) if sub[:teachers]
      course.sub_courses<<sub_course
    end
    course.has_sub=true
  end

  def after_create course
    course.create_default_sub_course
  end

  def after_update course
   if course.status_changed?
     course.sub_courses.update_all(:status=>course.status)
   end
  end
end
