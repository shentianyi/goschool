#encoding: utf-8
class ScheduleMailer < ActionMailer::Base
  default from: 'GOSchool<igoschool@163.com>'
  def download_notify recipients,url
    puts recipients
     @schedule_url=url
     begin
     mail(to:recipients,subject:'Schedule')
     rescue Exception=>e
       puts e.message
     end
  end
end
