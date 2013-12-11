#encoding: utf-8
class StudentPresenter<Presenter
  def_delegators :@student, :id,:name,:gender,:age,:school,:guardian,:phone,:referrer_id,:birthday,:student_status,:tenant_id
  attr_accessor :student

  def initialize(student)
    @student = student
  end
  
  def gender_display
    self.gender==0 ? '男' : '女'
  end

  def courses
    StudentCourse.find_by_student_id(self.id)
  end

  def age
    birthday = self.birthday
    now = Time.now
    
  end
  
  def status_display
    StudentStatus.display self.student_status
  end

  def potential_relation
    @relations = []
    Recommendation.new.get_potential_relation(self.tenant_id,self.id).each do |relation|
      s = Student.find_by_id(relation['id'])
      if s
        @relation<<s
      end
    end
  end

  def last_consulting
    Consultation.find_by_student_id(@student.id).first
  end

  def referrer
    if @student.referrer_id
      return Logininfo.find_by_id(self.referrer_id).student
    end
    return nil
  end
end
