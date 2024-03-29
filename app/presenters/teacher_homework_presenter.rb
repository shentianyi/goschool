#encoding: utf-8
class TeacherHomeworkPresenter<Presenter
    def_delegators :@homework,:id,:title,:content,:deadline,:unmark_number,:teacher_course_id,:status,:student_homeworks,:can_submit?,:attachments
    def initialize(homework)
      @homework=homework
    end

    def deadline_display
     self.deadline.strftime('%Y-%m-%d')
    end
    
    
    def status_display
      self.status  ?  '已完成批改' : '未完成批改' 
    end
end
