require 'test_helper'
require 'recommendation/student/score_student_refer_of_refer'
require 'tag_utility'

class ScoreStudentReferOfReferTest  < ActiveSupport::TestCase

  test 'Test Student with same referred' do
    tag_utility = TagUtility.new()
    StudentCourse.delete_all
    Student.delete_all
    Course.delete_all
    Tag.delete_all
    Logininfo.delete_all

    refer = Logininfo.create!({:email=>'test@test1.com',:password=>'12345678',:password_confirmation=>'12345678',:status=>0,:is_tenant=>false,:tenant_id=>1})


    ts = Student.new(name:'ts',referrer_id:refer.id)
    ts.save!

    refer_St = Student.new(name:'refer',logininfo_id:refer.id)
    refer_St.save!



    login_refer_of_refer =    Logininfo.create!({:email=>'test1@test1.com',:password=>'12345678',:password_confirmation=>'12345678',:status=>0,:is_tenant=>false,:tenant_id=>1})
    refer_of_refer_student =   Student.new(name:'refer',logininfo_id:login_refer_of_refer)

    refer_St.referrer_id=login_refer_of_refer.id

    0.upto(10) do |i|
      Student.create!({:name=>i.to_s})
    end

    cal = ScoreStudentReferOfRefer.new
    result = cal.calculate({:student_id=>ts.id})
    assert(result.length == 1)
    assert(result.keys[0]==refer_of_refer_student.id.to_s)

  end

end


#数据准备
#1.student 推荐人为student 2
#student 2 的推荐人为 student 3
#student 4，5，6，干扰项目