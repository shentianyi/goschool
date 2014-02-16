#1.	学校 同一学校同一年级 300分
#2.	年级 同一学校不同年级 100分
class ScoreStudentSchool


  def calculate(arg)
    result = {}
    student_id = arg[:student_id].to_s

    target = Student.find(student_id.to_i)

    potential = Student.where('school=?',target.school).all

    potential.each do |stud|

      if stud.id.to_s != student_id
       if stud.graduation.year == target.graduation.year
         result[stud.id.to_s] = 300
       else
         result[stud.id.to_s] = 100
       end if stud.graduation && target.graduation
      end
    end
    return result
  end


end

##数据准备
#1. STUDENT WITH SCHOOL 'abc' 毕业时间2012年
#1个学生相同学校相同毕业时间
#1个学生相同学校不相同毕业时间
#N个学生干扰项目
