#encoding: utf-8
class StudentPresenter<Presenter
  def_delegators :@student, :id,:name,:gender,:age,:school,:guardian,:guardian_phone,:phone,:referrer_id,:birthday,:student_status,:tenant_id,:graduation,:email,:address,:image_url
  attr_accessor :student

  def initialize(student)
    @student = student
  end
  
  def gender_
    self.gender==1 ? '男' : '女'
  end
  
  def birth_
    if self.birthday
      self.birthday.year.to_s + '-' + self.birthday.month.to_s + '-' +self.birthday.day.to_s
    end
  end

  def graduate_
    if self.graduation
      self.graduation.year.to_s + '-' + self.graduation.month.to_s + '-' + self.graduation.day.to_s
    end
  end

  def courses_
    StudentCourse.find_by_student_id(self.id)
  end

  def age_
    if self.birthday
      ((Time.now.to_i - self.birthday.to_i)/3600/24/365 + 1).to_s+'岁'
    end
  end
  
  def tags_
    TagUtility.new.get_tags(self.tenant_id,@student.class.name,self.id)
  end

  def status_
    StudentStatus.display self.student_status
  end

  def relation_
    @relations = []
    Recommendation.new.get_potential_relation(self.tenant_id,self.id).each do |relation|
      s = Student.find_by_id(relation['reced_id'])
      if s
        @relations<<s
      end
    end
    return @relations
  end

  def last_consultation_
    @lasts = Consultation.where("student_id = ?",self.id).order(:consult_time)
    if @lasts.first
      @presenter = ConsultationPresenter.new(@lasts.first)
      return @presenter.consult_time_display
    end
    return nil
  end

  def referrer_
    if self.referrer_id
      return Logininfo.find(self.referrer_id).student
    end
    return nil
  end
end
