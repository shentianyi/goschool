#encoding: utf-8
class SchedulePresenter<Presenter
  def_delegators :@schedule,:name,:parent_name,:id,:start_time,:end_time,:teachers
  def initialize(schedule)
    @schedule=schedule
  end

  def teacher_infos
    self.teachers.all
  end
  

  def to_json
    {course_name:self.parent_name,
      sub_course_name:self.name,
      start_time:self.start_time,
      end_time:self.end_time,
      teachers:self.teacher_infos.collect{|teacher| {id:teacher.id,name:teacher.name}}
    }
  end

end
