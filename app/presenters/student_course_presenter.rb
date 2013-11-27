#encoding: utf-8
class StudentCoursePresenter<Presenter
  def_delegators :student,:name,:id,:email,:gender,:phone,:paid,:image_url,:enrol_time

  def initialize(student)
    @student=student
  end

  def gender_display
    @student.gender==0 ? '男' : '女'
  end
  
  def paid_display
    @student.paid ? '是' : '否'
  end


  def to_jsons
    
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
