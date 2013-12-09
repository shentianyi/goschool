#encoding: utf-8
class EmailService
  def self.send_schedule_email type,institution_id
    case type
    when ScheduleType::EMPLOYEE
      send_employee_schedule_email type,institution_id
    when ScheduleType::TEACHER
      send_teacher_schedule_email type,institution_id
    when ScheduleType::STUDENT
      nil
    else
    nil
    end
  end

  def self.send_employee_schedule_email type,institution_id
    css= CourseScheduleService.new({type:type,institution_id:institution_id})
    if schedules=css.generate_schedule
      emails=User.get_employees(institution_id).collect{|user| user.email}
      send_schedule(schedules,emails)
    end
  end

  def self.send_teacher_schedule_email type,institution_id
    teachers=User.get_teachers(institution_id)
    teachers.each do |teacher|
     css=CourseScheduleService.new({type:type,institution_id:institution_id,user_id:teacher.id})
     if schedules=css.generate_schedule
       send_schedule schedules,teacher.email
     end
    end
  end

  private
  def self.send_schedule schedules,emails
      file_name=SecureRandom.uuid+'.pdf'
      schedule_pdf=PdfService.generate_schedule_pdf(schedules)
      url=AliyunOssService.store_schedule(file_name,schedule_pdf)
      ScheduleMailer.download_notify(emails,url).deliver
  end
end
