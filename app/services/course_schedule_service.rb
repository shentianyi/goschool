#encoding: utf-8
class CourseScheduleService

  attr_accessor :type, :institution_id, :user_id, :course_id, :student_id

  def initialize params={}
    self.type=params[:type]
    self.institution_id=params[:institution_id] if params[:institution_id]
    self.user_id=params[:user_id] if params[:user_id]
    self.course_id=params[:course_id] if params[:course_id]
    self.student_id=params[:student_id] if params[:student_id]
  end

  def generate_schedule
    schedules= case self.type
                 when ScheduleType::EMPLOYEE
                   generate_employee_schedule(self.institution_id)
                 when ScheduleType::TEACHER
                   generate_teacher_schedule(self.institution_id, self.user_id)
                 when ScheduleType::STUDENT
                   generate_student_schedule(self.institution_id, self.course_id, self.student_id)
                 else
                   nil
               end
    schedules=SchedulePresenter.init_presenters(schedules) if schedules
    return schedules
  end

  def generate_employee_schedule institution_id
    if Schedule.by_institution_id(institution_id).count>0
      return Schedule.by_institution_id(institution_id).all
    end
  end

  def generate_teacher_schedule institution_id, teacher_id
    if Schedule.by_teacher_id(institution_id, teacher_id).count>0
      return Schedule.by_teacher_id(institution_id, teacher_id).all
    end
  end

  def generate_student_schedule institution_id, course_id=nil, student_id=nil
    if student_id
      p={institution_id: institution_id, id: student_id}
      if Schedule.by_student_id(p).count>0
       puts "gen student schedule:#{student_id}"
        return Schedule.by_student_id(p).all
      end
    else
      p={institution_id: institution_id, id: course_id, type: 'Course'}
      if Schedule.by_course_id(p).count>0
        return Schedule.by_course_id(p).all
      end
    end
  end


end
