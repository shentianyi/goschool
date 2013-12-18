#encoding: utf-8
class HomeworkTeacherMenuType<StatusBase
  UNMARK=100
  LAST_10_DAYS=11
  LAST_20_DAYS=22
  LAST_30_DAYS=33
  LAST_40_DAYS=44
  Last_50_DAYS=55
  OTHER=66
  

  
 def self.condition type
   case type
   when UNMARK
       {status:HomeworkStatus::UNMARK}
   when OTHER
       ['created_at<=?',Date.current.ago((type-base_period).days)]
   else
        generate_time_condition type
   end
 end
 
 def self.generate_menu
  menus=[] 
  self.constants.each do |c|
    value=self.const_get(c.to_s)
    menus<< Menu.new({value:value,display: genenerate_menu_item(self.const_get(c.to_s))})
  end
  return menus
 end


 private 
 def self.generate_time_condition type 
       {created_at: Date.current.ago((type-1).days)..Date.current.ago((type-base_period-1).days)}
 end

 def self.genenerate_menu_item type
    case type
    when UNMARK
	'未完成批改'
    when OTHER
	'更多>>'
    else
       genenerate_time_menu type
    end
 end

 def self.genenerate_time_menu type
   Date.current.ago((type-1).days).strftime('%m/%d')+"~"+  Date.current.ago((type-base_period).days).strftime('%m/%d')
 end

 def self.base_period
   11
 end
end
