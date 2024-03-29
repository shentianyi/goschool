#encoding: utf-8
class CourseStudentPresenter<Presenter
  def_delegators :@student,:name,:id,:email,:gender,:phone,:image_url,:enrol_time,:student_course_id

  def initialize(student)
    @student=student
  end

  def gender_display
    @student.gender==0 ? '男' : '女'
  end
  
  def paid_display
    @student.paid==0 ?  '否' : '是'
  end
  
  def paid
    @student.paid==1
  end
  
  def enrol_time_display
    @student.enrol_time.strftime('%Y-%m-%d')
  end
  
  def to_json
    {
        name:self.name,
         id: self.id,
         email: self.email,
         gender: self.gender,
         gender_display: self.gender_display,
         phone: self.phone,
         paid: self.paid,
         image_url: self.image_url,
         enrol_time: self.enrol_time,
         paid_display: self.paid_display
    }
  end
end
