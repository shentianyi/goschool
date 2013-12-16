#推荐人的推荐人 加 80分
class ScoreStudentReferOfRefer

  def calculate(arg)
    result={}

    student_id = arg[:student_id].to_s

    student = Student.where('id=?',student_id.to_i).first


    begin
      result[student.referrer.student.referrer_id.to_s] = 80
    rescue

    end

    return result
  end

end

#数据准备
#1.student 推荐人为student 2
#student 2 的推荐人为 student 3
#student 4，5，6，干扰项目


