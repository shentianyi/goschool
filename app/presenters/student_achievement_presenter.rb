class StudentAchievementPresenter<Presenter
  def_delegators :@achieve,:id,:valuestring,:student_id,:achievement_id,:name,:type

  def initialize(achieve)
    @achieve = achieve
  end

  def final_grade
    ss = [] 
    ss = self.valuestring.split(';')
    {
      date:ss[0],
      grade:ss[1],
      enter_school:ss[2],
    }
  end

  def admitted
    ss = []
    ss = self.valuestring.split(';')
    {
      school:ss[0],
      specialty:ss[1],
      date:ss[2],
      grade:ss[3],
      scholarship:ss[4],
      scholarship_value: ss[5],
      offer:ss[6],
      offer_value:ss[7],
      admitted:ss[8],
      admitted_value:ss[9],
    }
  end

  def get_formatted
    case self.type
    when AchievementType::FINAL_GRADE
    when AchievementType::SUB_COURSE
      self.final_grade
    when AchievementType::ADMITTED
      self.admitted
    else
      self.valuestring
    end
  end

  def to_json
    {
      achieve:{
        id: self.id,
        object: self.get_formatted,
        student_id: student_id
      }
    }
  end
end
