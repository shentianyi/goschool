class StudentAchievementPresenter<Presenter
  def_delegators :@achieve, :id, :valuestring, :student_id, :achievement_id,:name,:tpye

  def initialize(achieve)
    @achieve = achieve
  end

  def final
    ss = []
    ss = valuestring.split(';')
    {
      abbreviation: ss[0],
      full_name: ss[1],
      date: ss[2]
    }
  end

  def final_grade
    ss = [] 
    ss = valuestring.split(';')
    {
      date:ss[0],
      grade:ss[1],
      enter_school:ss[2],
    }
  end

  def admitted
    ss = []
    ss = valuestring.split(';')
    {
      school:ss[0],
      specialty:ss[1],
      date:ss[2],
      scholarship:ss[3],
    }
  end
end
