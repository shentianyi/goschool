#encoding: utf-8
class TeacherCoursePresenter<Presenter
  def_delegators :@teacher_course,:course_id,:sub_course_id,:course_name,:sub_course_name,:is_default,:status,:type,:description,:start_date,:end_date,:user_id,:institution_id
  def initialize(teacher_course)
    @teacher_course=teacher_course
  end

  def unmark_number
    Homework.sub_total_unmark(self.sub_course_id,self.user_id)
  end

  def status_display
    CourseStatus.display self.status
  end

  def type_display
    CourseType.display self.type
  end

end
