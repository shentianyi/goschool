#encoding: utf-8
class HomeworkMenuType<StatusBase
  LAST_10_DAYS=11
  LAST_20_DAYS=22
  LAST_30_DAYS=33
  LAST_40_DAYS=44
  Last_50_DAYS=55
  OTHER=66
  

 def self.generate_menu
  menus=[] 
  self.constants.each do |c|
    value=self.const_get(c.to_s)
    menus<< Menu.new({value:value,display: genenerate_menu_item(self.const_get(c.to_s))})
  end
  return menus
 end

 
 def self.genenerate_time_menu type
   Date.current.ago((type-1).days).strftime('%m/%d')+"~"+  Date.current.ago((type-base_period).days).strftime('%m/%d')
 end

 def self.base_period
   11
 end
end
