#7.	曾经在同一course中学习 200分
class ScoreStudentCourse
  def calculate(arg)
    result ={}

    student_id = arg[:student_id].to_s

    attended_course = StudentCourse.where('student_id=?',student_id.to_i).pluck(:course_id)

    if attended_course
      classmate = StudentCourse.where('course_id in (?) and student_id <> ?',attended_course,student_id).pluck(:student_id)
      classmate.each do |cm|
        if result[cm.to_s]
          result[cm.to_s] = result[cm.to_s] + 50
        else
          result[cm.to_s] = 200
        end
       #第一个课程加200分，额外课程再加50分
      end
    end
    return result
  end
end

#测试数据
#1 student 参加过三个课程 course
#3 student 1 参加过相同的两个课程，1 参加过相同的一个课程，一个没有交集

