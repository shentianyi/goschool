#encoding: utf-8
class CourseStatus
 LOCK=0
 UNLOCK=1
 ONGOING=2
 FINISHED=3
 
 def self.display status
   case status
   when LOCK
     '已经注销'
   when UNLOCK
     '刚新建'
   when ONGOING
     '正在进行'
   when FINISHED
    '已经结束' 
   end
 end
end
