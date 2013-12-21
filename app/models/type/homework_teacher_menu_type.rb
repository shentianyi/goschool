#encoding: utf-8
class HomeworkTeacherMenuType< HomeworkMenuType
  UNFINISHED=100
  
  def self.condition type
    case type
    when UNFINISHED
      {status:false}
    when OTHER
      ['created_at<=?',Date.current.ago((type-base_period).days)]
    else
      generate_time_condition type
    end
  end



  private 
  def self.generate_time_condition type 
    {created_at: generate_time_condition_base(type)}
  end

  def self.generate_menu_item type
    case type
    when UNFINISHED
      '未完成批改'
    when OTHER
      '更多>>'
    else
      generate_time_menu type
    end
  end

end
