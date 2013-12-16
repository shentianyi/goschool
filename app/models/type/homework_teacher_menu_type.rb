#encoding: utf-8
class HomeworkTeacherMenuType<StatusBase
  ONGOING=100
  LAST_10_DAYS=10
  LAST_20_DAYS=20
  LAST_30_DAYS=30
  LAST_40_DAYS=40
  Last_50_DAYS=50
  OTHER=60 
  

  
 def self.condition type
   case type
   when ONGOING
       {status:HomeworkStatus::ONGOING}
   when OTHER
       ['created_at>=?',Time.now.ago(OTHER.days)]
   else
        generate_time_condition type
   end
 end
 
 def self.generate_menu
  menus=[] 
  self.constants.each do |c|
    value=self.const_get(c.to_s)
    menus<< Menu.new({value:value,dispaly: genenerate_menu_item(self.const_get(c.to_s))})
  end
  return menus
 end


 private 
 def self.generate_time_condition type
       {created_at:[Time.now.ago((type-base_peroid).days)..Time.now.ago(type.days)]}
 end

 def self.genenerate_menu_item type
    case type
    when ONGOING
	'未完成批改'
    when OTHER
	'更多'
    else
       genenerate_time_menu type
    end
 end

 def self.genenerate_time_menu type
  "#{Time.now.ago((type-base_peroid).days).strftime('%m/%d')}~#{Time.now.ago(type.days).strftime('%m/%d')}"
 end

 def self.base_period
   10
 end
end
