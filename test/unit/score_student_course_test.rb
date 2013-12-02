require 'test_helper'
require 'recommendation/student/score_student_course'
require 'tag_utility'
class ScoreStudentCourseTest  < ActiveSupport::TestCase
  test "student in same course" do
    tag_utility = TagUtility.new()
    StudentCourse.delete_all
    Student.delete_all
    Course.delete_all
    Tag.delete_all

    ts = Student.new(name:'ts')
    ts.save
    s1 = Student.new(name:'s1')
    s1.save
    s2 = Student.new(name:'s2')
    s2.save
    s3 = Student.new(name:'s3')
    s3.save

    c1 = Course.new(name:'c1',actual_number:1)
    c1.save
    c2 = Course.new(name:'c2',actual_number:1)
    c2.save
    c3 = Course.new(name:'c3',actual_number:1)
    c3.save

    tr1=StudentCourse.new(student_id:ts.id,course_id:c1.id)
    tr1.save
    tr2=StudentCourse.new(student_id:ts.id,course_id:c2.id)
    tr2.save
    tr3=StudentCourse.new(student_id:ts.id,course_id:c3.id)
    tr3.save


    sr1=StudentCourse.new(student_id:s1.id,course_id:c1.id)
    sr1.save

    sr2=StudentCourse.new(student_id:s1.id,course_id:c2.id)
    sr2.save

    sr3=StudentCourse.new(student_id:s2.id,course_id:c3.id)
    sr3.save

    cal = ScoreStudentCourse.new
    result = cal.calculate({:student_id=>ts.id})
    assert(result.length==2,"length is #{result}")
    assert(result[s1.id.to_s]==250)
    assert(result[s2.id.to_s]==200)

  end
end

#1 student 参加过三个课程 course
#3 student 1 参加过相同的两个课程，1 参加过相同的一个课程，一个没有交集
