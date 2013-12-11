#encoding: utf-8
class HomeworkTeacherMenuType
  ONGOING=100
  LAST_10_DAYS=10
  LAST_20_DAYS=20
  LAST_30_DAYS=30
  LAST_40_DAYS=40
  Last_50_DAYS=50
  OTHER=60 
  
  class<<self
    define_method(:include?){|type|
       unless self.const_defined?(:TYPES)
         self.const_set(:TYPES, self.constants.map{|c| self.const_get(c.to_s)})
       end
      TYPES.include?(type)
    }
  end
  
 def self.condition type
   case type
   when ONGOING
       {status:HomeworkStatus::ONGOING}
   when OTHER
       ['created_at>=?',Time.now.ago(OTHER.days)]
   else
        generate_time_condition
   end
 end
 
 def self.generate_menu
   
 end


 private 
 def self.generate_time_condition type
       {created_at:[Time.now.ago((type-10).days)..Time.now.ago(type.days)]}
 end
end
