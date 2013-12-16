class StudentAchievementPresenter<Presenter
  def_delegators :@achievement, :id,:type,:achievementstring,:student_id

  def initialize(achievement)
    @achievement = achievement
  end
end
