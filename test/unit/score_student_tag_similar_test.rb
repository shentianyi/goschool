require 'test_helper'
require 'recommendation/student/score_student_tag_similar'
require 'tag_utility'
class ScoreStudentReferTest  < ActiveSupport::TestCase
  test 'test school and grade' do
    tag_utility = TagUtility.new()
    StudentCourse.delete_all
    Student.delete_all
    Course.delete_all
    Tag.delete_all
    Logininfo.delete_all


    ts = Student.new(name:'ts')
    ts.save
    tag_utility.add_or_update('1',Student.name,ts.id,['托福','美国','出国','SAT','summer','住宿'])


    s1 = Student.new(name:'s1')
    s1.save
    tag_utility.add_or_update('1',Student.name,s1.id,['托福','美国','出国','SAT','summer','住宿'])

    s2 = Student.new(name:'s2')
    s2.save
    tag_utility.add_or_update('1',Student.name,s2.id,['托福','美国','出国','k11','k22','k33'])

    s3 = Student.new(name:'s3')
    s3.save
    tag_utility.add_or_update('1',Student.name,s3.id,['托福','p5','p4','p1','p22','p33'])

    s4 = Student.new(name:'s4')
    s3.save
    tag_utility.add_or_update('1',Student.name,s4.id,['tp1','tp5','tp4','tp1','tp22','tp33'])

    cal = ScoreStudentTagSimilar.new
    result = cal.calculate({:tenant_id=>'1',:entity_type_id=>Student.name,:student_id=>ts.id.to_s})
    assert(result.length == 3)
    assert(result[s1.id.to_s] == 50)
    assert(result[s2.id.to_s]==25)
    assert(result[s3.id.to_s]==8)

  end


end


#数据准备
#1. student 6个tag
#1. student 3个相同Tag
#1. student 2个相同tag
#1. Student 1个相同TAG
#1 student 没有相同TAG