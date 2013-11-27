class ScoreStudentReferOfRefer

  def calculate(arg)
    student_id = arg[:student_id]

    student = Student.where('id=?',student_id).first
    if student
      refer = student.referrer.student.referrer
    end



  end

end
