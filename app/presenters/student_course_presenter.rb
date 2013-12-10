#encoding: utf-8
class StudentCoursePresenter<Presenter
  def_delegators :@course,:name,:id,:lession,:start_date,:end_date,:paid

  def initialize(course)
    @course = course
  end

  def paid_display
    @course.paid ? '是': '否'
  end

  def to_json
    {
      name: self.name,
      id: self.id,
      lesson: self.lesson,
      paid: self.paid,
      pair_display: self.paid_display,
      performance: ''
    }
  end
end
