#encoding: utf-8
class StudentPresenter<Presenter
  def_delegators :@student, :id,:name,:gender,:age,:school,:guardian,:phone,:referrer_id
  
  def initialize(studnet)
    @student = student
  end
  
  def gender_display
    @student.gender==0 ? '男' : '女'
  end

  def courses
    StudentCourse.find_by_student_id(self.id)
  end

  def potential_relation
    Recommendation.new.get_potential_relation(self.tenant_id,self.id)
  end

  def tags
    TagUtility.new.get_tags(self.tenant_id,self.class.name,self.id)
  end

  def last_consulting
    Consultation.find_by_student_id(self.id,:order=>"created_at")
  end
end
