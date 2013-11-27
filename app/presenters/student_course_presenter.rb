#encoding: utf-8
class StudentCoursePresenter<Presenter
  def initialize(course)
    @course=course
    @students=@course.students.select('student_courses.*,student_courses.created_at as enrol_time,students.*')
  end


  def to_jsons
    jsons=[]
	  @students.each do |student|
	    jsons<< self.to_json(student)
	  end 
    return jsons
  end
  
  def to_json student
    {
         name:student.name,
         id: student.id,
         email: student.email,
         gender: student.gender,
         gender_display: student.gender==0 ? '女' : '男',
         phone: student.phone,
         paid: student.paid,
         image_url: student.image_url,
         enrol_time: student.enrol_time,
         paid_display: student.paid ? '是' : '否'
    }
  end
end
