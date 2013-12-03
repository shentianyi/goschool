#encoding: utf-8
class Schedule < ActiveRecord::Base
  belongs_to :sub_course
  delegate :course,:to=>:sub_course
  has_many :teachers,:through=>:sub_course
  attr_accessible :end_time, :start_time
  attr_accessible :sub_course_id

  validate :validate_save
  
  def self.by_id id
    joins(:sub_course).where(:id=>id).select('*,sub_courses.*').first
  end
  
  def self.between_date params
    joins(:sub_course).where(start_time:params[:start_date]..params[:end_date],sub_courses:{institution_id:params[:institution_id],status:CourseStatus::UNLOCK}).select('*,sub_courses.*').all
  end
  
  def self.by_course_id params
    if params[:type]=='SubCourse'
      joins(:sub_course).where(sub_courses:{id:params[:id],institution_id:params[:institution_id],status:CourseStatus::UNLOCK}).select('*,sub_courses.*').all
    elsif params[:type]=='Course'
      joins(:sub_course).where(sub_courses:{course_id:params[:id],institution_id:params[:institution_id],status:CourseStatus::UNLOCK}).select('*,sub_courses.*').all
    else
      []
    end 
  end
  
  private
  def validate_save
    teachers=self.sub_course.teachers
    condi=[self.start_time,self.end_time,self.start_time,self.end_time]
    teachers.each do |teacher|
      new_record_where=teacher.schedules.where('(schedules.start_time between ? and ?) or schedules.end_time between ? and ?',*condi)
      ex= new_record? ? new_record_where.first : new_record_where.where("schedules.id<>?",self.id).first
      errors.add(:start_time,"冲突：老师#{teacher.name}在此时间段已经有排课") if ex
    end
  end
end
