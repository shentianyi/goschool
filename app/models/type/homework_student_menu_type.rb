#encoding: utf-8
class HomeworkStudentMenuType< HomeworkMenuType
  UNSUBMIT=100
  SUBMITED=99
  UNMARKED=98
  
 def self.condition type,student_id
   return nil if is_pin?(type)
   case type
   when UNSUBMIT
     ["homeworks.id not in (?)",StudentHomewrok.where(student_id:student_id).pluck(:homewrok_id)]
   when UNMARKED
     {marked:false}
   when OTHER
     ['updated_at<=?',Date.current.ago((type-base_period).days)]
   else
        generate_time_condition type
   end
 end

def self.is_pin? type
  [SUBMITED].include? type
end

 private 
 def self.generate_time_condition type 
       {updated_at: generate_time_condition(type)}
 end

 def self.generate_menu_item type
    case type
    when UNSUBMIT
       '未提交'
    when OTHER
      	'更多>>'
    else
       generate_time_menu type
    end
 end

end
