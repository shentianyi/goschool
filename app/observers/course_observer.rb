#encoding: utf-8
class CourseObserver<ActiveRecord::Observer
  observe :course 
  # def before_create course
    # course.subs.each do |sub|
      # puts "---------------------#{sub}"
      # sub_course=SubCourse.new(:name=>sub[:name],:parent_name=>course.name,:institution_id=>course.institution_id,:is_default=>false)
      # sub_course.assign_teachers(sub[:teachers].values) if sub.has_key?(:teachers)
      # course.sub_courses<<sub_course
    # end if course.subs
    # course.has_sub=true if course.subs
  # end

  def after_create course
    course.create_default_sub_course
    course.add_tags
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
