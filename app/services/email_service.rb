#encoding: utf-8
class EmailService
  def self.send_schedule_email type,institution_id
    case type
    when ScheduleType::ALL
      send_employee_schedule_email ScheduleType::EMPLOYEE,institution_id
      send_teacher_schedule_email ScheduleType::TEACHER,institution_id
      send_student_schedule_email ScheduleType::STUDENT,institution_id
    when ScheduleType::EMPLOYEE
      send_employee_schedule_email type,institution_id
    when ScheduleType::TEACHER
      send_teacher_schedule_email type,institution_id
    when ScheduleType::STUDENT
      send_student_schedule_email type,institution_id
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

  def self.send_student_schedule_email type,institution_id
    Course.where('actual_number>0').all.each do |course|
      css=CourseScheduleService.new({type:type,institution_id:institution_id,course_id:course.id})
      if schedules=css.generate_schedule
        emails=course.students.pluck(:email)
        send_schedule schedules,emails
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
