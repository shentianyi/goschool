#encoding: utf-8
class AchievementType
  FINAL = 100
  ADMITTED = 200
  FINAL_GRADE = 300
  SUB_COURSE = 400

  def self.display type
    case type
    when FINAL
      '最终成就'
    when ADMITTED
      '最终录取'
    when FINAL_GRADE
      '最终成绩'
    when SUB_COURSE
      '课程名称'
    else
      nil
    end
  end

  def self.can_have_sub? type
    type == FINAL_GRADE ? ture : false
  end

  def self.valid_type? type
    if self.display type
      return true
    else
      return false
    end
  end
end
