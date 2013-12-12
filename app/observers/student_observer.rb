#encoding: utf-8
class StudnetObserver<ActiveRecord::Observer
  observe :student
  
  def after_save student
    TagService.add_tags(student) if student.tags
  end
end
