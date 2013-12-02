require 'test_helper'
require 'recommendation/student/score_student_school'
require 'tag_utility'
class ScoreStudentReferTest  < ActiveSupport::TestCase
  test 'test school and grade' do
    tag_utility = TagUtility.new()
    StudentCourse.delete_all
    Student.delete_all
    Course.delete_all
    Tag.delete_all
    Logininfo.delete_all
                                         school='abc'
    graduation= Date.new(2012)
    ts = Student.new(name:'TS',school:school,graduation:graduation,tenant_id:1)
    ts.save!
    s1 =Student.new(name:'s1',school:school,graduation:graduation,tenant_id:1)
    s1.save!

    s2 =   Student.new(name:'s2',school:school,graduation:Date.new(1990),tenant_id:1)
    s2.save!

    s3 =   Student.new(name:'s3',school:school + 'sss',graduation:graduation,tenant_id:1)
    s3.save!

    1.upto(5) do |i|
      Student.create!({:name=>i.to_s,:school=>school + i.to_s,:graduation=>Date.new(1989),:tenant_id=>1})
    end

    cal = ScoreStudentSchool.new
    result =cal.calculate({:student_id=>ts.id.to_s})
    assert(result.length == 2,"actual #{result},s1 id:#{s1.id}, s2 id: #{s2.id}")
    assert(result[s1.id.to_s] == 300)
    assert(result[s2.id.to_s]==100)

  end
end

#数据准备
#1. STUDENT WITH SCHOOL 'abc' 毕业时间2012年
#1个学生相同学校相同毕业时间
#1个学生相同学校不相同毕业时间
#N个学生干扰项目