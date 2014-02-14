#encoding: utf-8
class CourseObserver<ActiveRecord::Observer
  observe :course
  def after_create course
    course.create_default_sub_course
    course.add_tags
    course.migrate_materials
  end

  def after_update course
    if course.status_changed?
      course.sub_courses.update_all(:status=>course.status)
    end
    if course.name_changed?
      course.sub_courses.update_all(:parent_name=>course.name)
    end
  end
end
