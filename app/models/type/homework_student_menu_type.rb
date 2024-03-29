#encoding: utf-8
class HomeworkStudentMenuType< HomeworkMenuType
  UNSUBMIT=100
  SUBMITED=98
  UNMARKED=99
  
 def self.condition type
   return nil if is_pin?(type)
   case type
   when UNMARKED
     {marked:false}
   when OTHER
     ['student_homeworks.updated_at<=?',Date.current.ago((type-base_period).days)]
   else
        generate_time_condition type
   end
 end

def self.is_pin? type
  [SUBMITED].include? type
end

 private 
 def self.generate_time_condition type 
       {updated_at: generate_time_condition_base(type)}
 end

 def self.generate_menu_item type
    case type
    when UNSUBMIT
       '未提交'
     when SUBMITED
       '已提交'
     when UNMARKED
       '未批改'
    when OTHER
      	'更多>>'
    else
       generate_time_menu type
    end
 end

end
