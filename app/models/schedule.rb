#encoding: utf-8
class Schedule < ActiveRecord::Base
  belongs_to :sub_course
  attr_accessible :end_time, :start_time
  attr_accessible :sub_course_id

  validate :validate_save
  private
  def validate_save
    teachers=self.sub_course.teachers
    condi=[self.start_time,self.end_time,self.start_time,self.end_time]
    teachers.each do |teacher|
      new_record_where=teacher.schedules.where('(schedules.start_time between ? and ?) or schedules.end_time between ? and ?',*condi)
      count= new_record? ? new_record_where.count : new_record_where.where("schedules.id<>?",self.id).count
      errors.add(:start_time,"冲突：老师#{teacher.name}在此时间段已经有排课") if count>0
    end
  end
end
