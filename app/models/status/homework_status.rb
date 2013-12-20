#encoding: utf-8
class HomeworkStatus
  UNFINISHED=1
  FINISHED=2
  
  def self.display status
   case status
   when UNFINISHED
     '未完成批改'
   when FINISHED
     '已完成批改'
   end
 end
end
