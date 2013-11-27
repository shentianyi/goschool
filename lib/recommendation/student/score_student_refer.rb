class ScoreStudentRefer
  def calculate(arg)
    student_id = arg[:tenant_id]
    student =  Student.where('id=?',student_id.to_i).first
    result ={}
    if student
      referred = Student.where('referrer_id=? and id<>?',student.referrer_id,student_id.to_i).all

      referred.each do |refer|
         result[refer.id.to_s]=80
      end
    end
    return result
  end
end
