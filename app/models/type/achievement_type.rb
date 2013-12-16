#encoding: utf-8
class AchievementType
  FINAL = 100
  ADMITTED = 200
  FINAL_GRADE = 300

  def sekf.display type
    case type
    when FINAL
      '最终成就'
    when ADMITTED
      '最终录取'
    when FINAL_GRADE
      '最终成绩'
    else
      nil
    end
  end
end
