#encoding: utf-8
class CourseScheduleService

  attr_accessor :type,:institution_id,:user_id
  def initialize params={}
    self.type=params[:type]
    self.institution_id=params[:institution_id] if params[:institution_id]
    self.user_id=params[:user_id] if params[:user_id]
  end

  def generate_schedule
    schedules= case self.type
    when ScheduleType::EMPLOYEE
      generate_employee_schedule_by_institution(self.institution_id)
    when ScheduleType::TEACHER
      generate_teacher_schedule(self.institution_id,self.user_id)
    when ScheduleType::STUDENT
      nil
    else
    nil
    end
    schedules=SchedulePresenter.init_presenters(schedules) if schedules
    return schedules
  end

  def generate_employee_schedule_by_institution institution_id
    if Schedule.count_by_institution_id(institution_id)>0
      return Schedule.by_insititution_id(institution_id)
    end
  end

  def generate_teacher_schedule institution_id,teacher_id
    if Schedule.count_by_teacher_id(institution_id,teacher_id)>0
      Schedule.by_teacher_id(institution_id,teacher_id)
    end
  end
end
