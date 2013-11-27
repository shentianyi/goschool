#1.	学校 同一学校同一年级 100分
#2.	年级 同一学校不同年级 80分
class ScoreStudentSchool


  def calculate(arg)
    result = {}
    student_id = arg[:student_id]

    target = Student.find(student_id.to_i)

    potential = Student.where('school=?',target.school).all

    potential.each do |stud|

      if stud.id.to_s != student_id
       if stud.graduation.year == target.graduation.year
         result[stud.id.to_s] = 300
       else
         result[stud.id.to_s] = 100
       end
      end
    end
    return result
  end


end