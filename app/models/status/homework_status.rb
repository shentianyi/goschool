#encoding: utf-8
class HomeworkStatus
  LOCK=0
  UNMARK=1
  FINISHED=2
  
  def self.display status
   case status
   when LOCK
     '已锁定'
   when UNMARK
     '未批改'
   when FINISHED
     '已批改'
   end
 end
end
