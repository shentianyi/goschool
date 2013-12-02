#7.	曾经在同一course中学习 200分
class ScoreStudentCourse
  def calculate(arg)
    result ={}

    student_id = arg[:student_id]

    attended_course = StudentCourse.where('student_id=?',student_id.to_i).pluck(:course_id)

    if attended_course
      classmate = StudentCourse.where('course_id in (?)',attended_course).pluck(:student_id)
      classmate.each do |cm|
      result[cm.to_s] = 200
      end
    end
    return result
  end
end

