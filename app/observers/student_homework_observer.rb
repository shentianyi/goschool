#encoding: utf-8
class StudentHomeworkObserver<ActiveRecord::Observer
  observe :student_homework
  def after_create student_homework
    student_homework.homework.increment!(:unmark_number)
  end
  
  def after_update student_homework
    if student_homework.marked_changed?
      student_homework.homework.decrement!(:unmark_number)
    end
  end
end
