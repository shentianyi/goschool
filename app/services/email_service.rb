#encoding: utf-8
class EmailService
  def self.send_schedule_email type,institution_id
    css= CourseScheduleService.new({type:type,institution_id:institution_id})
    if schedules=css.generate_schedule
      file_name=SecureRandom.uuid+'.pdf'
      schedule_pdf=PdfService.generate_schedule_pdf(schedules)
      url=AliyunOssService.store_schedule(file_name,schedule_pdf)
      ScheduleMailer.download_notify(css.user_emails,url).deliver
    end
  end
end
