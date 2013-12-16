#encoding: utf-8
class TeacherCoursePresenter<Presenter
  def_delegators :@sub_course,:course_id,:is_default,:institution_id
  def_delegators :@course,:start_date,:end_date,:type,:description
  def initialize(sub_course,teacher_id)
    @sub_course=sub_course
    @course=sub_course.course
    @teacher_id=teacher_id
  end

  def course_name
    @course.name
  end

  def sub_class_name
    @sub_course.name
  end

  def unmark_number
    Homework.sub_total_unmark(@sub_course.id,@teacher_id)
  end

  def self.init_presenters sub_courses,teacher_id
    sub_courses.map{|sub_course| self.new(sub_course,teacher_id)}
  end
end
