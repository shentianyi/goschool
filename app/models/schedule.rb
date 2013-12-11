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
  
  def self.by_insititution_id institution_id
   base_query(institution_id)
  end
   
   def self.by_teacher_id institution_id,teacher_id
     base_query(institution_id).joins(:teachers).where(teacher_courses:{user_id:teacher_id})
   end
   
  def self.between_date params
    base_query(params[:institution_id]).joins(:teachers).where(start_time:params[:start_date]..params[:end_date])
  end
  
  def self.by_teacher_date params
    between_date(params).where(teacher_courses:{user_id:params[:teacher_id]})
  end
  
  def self.by_course_id params
    bq=base_query(params[:institution_id])
    if params[:type]=='SubCourse'
     bq.where(sub_courses:{id:params[:id]})
    elsif params[:type]=='Course'
       bq.where(sub_courses:{course_id:params[:id]})
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
  
  def self.base_query institution_id=nil
    if institution_id
     return  joins(:sub_course).where(sub_courses:{institution_id:institution_id,status:CourseStatus::UNLOCK}).select('*,sub_courses.*')
     else
        return joins(:sub_course).where(sub_courses:{status:CourseStatus::UNLOCK}).select('*,sub_courses.*')
     end
  end
end
