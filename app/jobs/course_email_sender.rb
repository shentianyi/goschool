#encoding: utf-8
class CourseEmailSender
  @queue='course_email_sender_queue'

  def self.perform type, institution_id, user_ids= nil
    EmailService.send_schedule_email(type.to_i, institution_id, user_ids)
  end
end
