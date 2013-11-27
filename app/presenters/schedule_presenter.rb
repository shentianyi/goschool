#encoding: utf-8
class SchedulePresenter<Presenter
  def_delegators :@schedules,:name,:parent_name,:id,:start_time,:end_time,:teachers
  def initialize(schedule)
    @schedules=schedule
  end

  def teacher_infos
    self.teachers.collect{|teacher| {id:teacher.id,name:teacher.name}}
  end

  def to_json
    {course_name:self.parent_name,
      sub_course_name:self.name,
      start_time:self.start_time,
      end_time:self.end_time,
      teachers:self.teacher_infos
    }
  end

end
