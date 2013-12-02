require 'test_helper'
require 'recommendation/student/score_student_refer'
require 'tag_utility'
class ScoreStudentReferTest  < ActiveSupport::TestCase
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


    0.upto(9) do |i|
      if i<= 4
        Student.create({:name => i.to_s,:referrer_id=>refer.id})
      end
    end

    cal = ScoreStudentRefer.new
    result = cal.calculate({:student_id=>ts.id})
    assert(result.length == 5)
    result.keys.each do |key|
      assert(result[key] == 80)
    end

  end

end