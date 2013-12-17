#encoding: utf-8
class StudentHomeworkObserver<ActiveRecord::Observer
  observe :student_homewrok
  def after_create student_homewrok
    student_homewrok.homewrok.increment!(:unmark_number)
  end
  
  def after_update student_homewrok
    if student_homewrok.marked_changed?
      student_homewrok.homewrok.decrement!(:unmark_number)
    end
  end
end
