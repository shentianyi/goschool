#encoding: utf-8
class CourseScheduleService

  attr_accessor :type,:institution_id
  def initialize params={}
    self.type=params[:type].to_i
    self.institution_id=params[:institution_id]
  end

  def generate_schedule
    schedules= case self.type
    when ScheduleType::EMPLOYEE
      generate_employee_schedule_by_institution(self.institution_id)
    when ScheduleType::TEACHER
      nil
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
      emails=User.get_employees(institution_id).collect{|user| user.email}
      return Schedule.by_insititution_id(institution_id)
    end
  end

end
