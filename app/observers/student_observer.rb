#encoding: utf-8
class StudnetObserver<ActiveRecord::Observer
  observe :student
  
  def after_save student
    TagService.add_tags(student)
  end
end
