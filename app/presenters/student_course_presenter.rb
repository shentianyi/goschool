#encoding: utf-8
class StudentCoursePresenter<Presenter
  def_delegators :@student_course, :lesson,:start_date,:end_date,:status,:student_course_id,:progress,:name,:paid

  def initialize(student_course)
    @student_course = student_course
  end

  def id_display
    self.student_course_id
  end

  def paid_display
    self.paid == 0 ? '没有支付':'已经支付'
  end

  def lesson_display
    self.lesson.to_s
  end

  def period_display
    self.start_date.year.to_s+'.'+self.start_date.month.to_s+'.'+self.start_date.day.to_s + '-' + self.end_date.year.to_s+'.'+self.end_date.month.to_s+'.'+self.end_date.day.to_s
  end
end
