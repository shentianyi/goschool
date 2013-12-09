#encoding: utf-8
class CourseTeacherPresenter<Presenter
  def_delegators :@teacher,:name,:id,:email,:image_url,:course_name,:sub_course_name,:sub_course_id
  def initialize(teacher)
    @teacher=teacher
  end

end
