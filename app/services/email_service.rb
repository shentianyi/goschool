#encoding: utf-8
class EmailService
  def self.send_schedule_email type,institution_id
    if schedules=CourseScheduleService.new({type:type,institution_id:institution_id}).generate_schedule
      file_name=SecureRandom.uuid+'.pdf'
      schedule_pdf=PdfService.generate_schedule_pdf(schedules)
      url=AliyunOssService.store_schedule(file_name,schedule_pdf)
    end
  end
end
