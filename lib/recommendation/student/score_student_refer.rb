#学生的推荐者还推荐过的人，加80分
class ScoreStudentRefer
  def calculate(arg)
    student_id = arg[:student_id].to_s
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

#数据准备
#1. TS student 推荐人ID 为 20
#2. 10 个学生，3个推荐人ID 为20

