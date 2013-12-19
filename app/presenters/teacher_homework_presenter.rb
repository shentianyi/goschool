#encoding: utf-8
class TeacherHomeworkPresenter<Presenter
    def_delegators :@homework,:id,:title,:content,:deadline,:unmark_number,:teacher_course_id,:status,:student_homeworks
    def initialize(homework)
      @homework=homework
    end

    def deadline_display
     self.deadline.strftime('%Y-%m-%d')
    end
    
    def status_display
      HomeworkStatus.display self.status
    end
end