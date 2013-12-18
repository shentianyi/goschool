#encoding: utf-8
class HomeworkMenuType<StatusBase
   
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
