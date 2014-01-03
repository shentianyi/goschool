#encoding: utf-8
class FrontHomeworkPresenter<Presenter
  def_delegators :@student_homework,:id,:title,:deadline,:content,:course_name,:sub_course_name

  def initialize(student_homeword)
    @student_homework = student_homeword
  end

  def attachments
    @student_homework.attachments
  end

  def deadline_time
    self.deadline.strftime("%Y-%m-%d")
  end

  def homework_course
    self.course_name + (self.sub_course_name ? self.sub_course_name : '')
  end
end