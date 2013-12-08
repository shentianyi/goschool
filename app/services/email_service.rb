#encoding: utf-8
class EmailService
  def self.send_schedule_email type,institution_id
    css=CourseScheduleService.new({type:type,institution_id:institution_id})
    if schedules=css.generate_schedule
      file=PdfService.generate_schedule_pdf(schedules)

    end
  end
end
