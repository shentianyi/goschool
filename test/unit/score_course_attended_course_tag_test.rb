require 'test_helper'
require 'tag_utility'
require 'recommendation/course/score_course_attended_course_tag'
class ScoreCourseAttendedCourseTagTest  < ActiveSupport::TestCase
   test "normal calculation" do
     tag_utility = TagUtility.new()
     StudentCourse.delete_all
     Student.delete_all
     Course.delete_all
     Tag.delete_all


     # insert course
     c1 = Course.new(tenant_id:1,name:'c1',has_sub:false,actual_number:1)
     c1.save!
     tag_utility.add_or_update(1,Course.name,c1.id,['托福','美国','出国','SAT','summer','住宿'])

     c2 = Course.new(tenant_id:1,name:'c2',has_sub:false,actual_number:1)
     c2.save!
     tag_utility.add_or_update(1,Course.name,c2.id,['托福','美国','出国','x3','x2','x1'])
     c3 = Course.new(tenant_id:1,name:'c3',actual_number:1)
     c3.save!
     tag_utility.add_or_update(1,Course.name,c3.id,['托福','美国','y4','y3','y2','y1'])

    #insert student
    s1 = Student.new(tenant_id:1,name:'s1',phone:'2222',guardian:'ssss',guardian_phone:'wwwww')
    s1.save!
    tag_utility.add_or_update(1,Student.name,s1.id,['托福','美国','出国','SAT','summer','住宿'])

     s2 = Student.new(tenant_id:1,name:'s2',phone:'2222',guardian:'ssss',guardian_phone:'wwwww')
     s2.save!
     tag_utility.add_or_update(1,Student.name,s2.id,['托福','美国','出国','k11','k22','k33'])

     s3 = Student.new(tenant_id:1,name:'s3',phone:'2222',guardian:'ssss',guardian_phone:'wwwww')
     s3.save!
     tag_utility.add_or_update(1,Student.name,s3.id,['p6','p5','p4','p1','p22','p33'])

     r1=StudentCourse.new(student_id:s2.id,course_id:c2.id)
     r1.save!
     r2=StudentCourse.new(student_id:s1.id,course_id:c3.id)
     r2.save!

     assert(Student.count ==3)
     assert(Course.count ==3)
     assert(StudentCourse.count==2)

     #result1= tag_utility.find_entity_and_tag_count_in_entity_type("1",Student.name,['托福','美国','出国','SAT','summer','住宿'],false)
     #assert(result1==0,"actual result: #{result1}")
     #assert(tag_utility.get_tags("1",Student.name,))
     cal = ScoreCourseAttendedCourseTag.new
     result = cal.calculate({:tenant_id=>'1',:course_id=>c1.id,:entity_type_id=>Course.name})
     assert(result.length==2,"actual: #{result}")
     assert(result[s1.id.to_s] == 73)
     assert(result[s2.id.to_s]==10)
   end

end




#
#测试数据准备
#1. 三个课程，一个为主课程，一个为匹配度50%课程，一个为10%课程
#2.三个学生，一个为TAG匹配度0，一个匹配度50，一个匹配度100；一个上过匹配度50的课程，一个上过匹配度10的课程
#最终：两个学生，一个分数10，一个80
#


