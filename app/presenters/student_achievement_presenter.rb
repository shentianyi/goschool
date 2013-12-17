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
    
  end

  def admitted
    
  end
end
