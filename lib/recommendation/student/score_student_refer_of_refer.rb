class ScoreStudentReferOfRefer

  def calculate(arg)
    result={}

    student_id = arg[:student_id]

    student = Student.where('id=?',student_id.to_i).first


    begin
      result[student.referrer.student.referrer_id.to_s] = 80
    rescue

    end

    return result
  end

end
