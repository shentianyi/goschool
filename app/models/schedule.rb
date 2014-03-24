#encoding: utf-8
class Schedule < ActiveRecord::Base
  belongs_to :sub_course
  belongs_to :tenant
  delegate :course, :to => :sub_course
  has_many :teachers, :through => :sub_course
  attr_accessible :end_time, :start_time, :remark, :color
  attr_accessible :sub_course_id

  validate :validate_save
  acts_as_tenant(:tenant)

  def self.by_id id
    joins(:sub_course).where(:id => id).select('*,sub_courses.*').first
  end

  def self.by_institution_id institution_id
    base_query(institution_id)
  end

  def self.by_teacher_id institution_id, teacher_id
    base_query(institution_id).joins(:teachers).where(teacher_courses: {user_id: teacher_id})
  end

  def self.between_date params
    base_query(params[:institution_id]).where(start_time: params[:start_date]..params[:end_date])
  end

  def self.by_teacher_date params
    joins(:sub_course => [:institution, :teacher_courses])
    .where(start_time: params[:start_date]..params[:end_date], teacher_courses: {user_id: params[:teacher_id]})
    .where(SubCourse.status_neq)
    .select('institutions.name as institution_name,sub_courses.*,schedules.*').order('start_time')
  end

  def self.by_course_id params
    bq=base_query(params[:institution_id])
    if params[:type]=='SubCourse'
      bq.where(sub_courses: {id: params[:id]})
    elsif params[:type]=='Course'
      bq.where(sub_courses: {course_id: params[:id]})
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def self.by_student_id params
    base_query(params[:institution_id]).where(sub_courses: {course_id: StudentCourse.where(student_id: params[:id]).pluck(:course_id)})
  end

  private
  def validate_save
    if self.sub_course_id.blank?
      errors.add(:sub_course_id, '请正确选择课程')
    else
      if self.course.status==CourseStatus::FINISHED
        errors.add(:sub_course_id, '课程已结束，不可排课')
      else
        if self.start_time>=self.end_time
          errors.add(:start_time, '开始时间应小于结束时间')
        else
          teachers=self.sub_course.teachers
          condi=[self.start_time, self.end_time, self.start_time, self.end_time]
          teachers.each do |teacher|
            new_record_where=teacher.schedules.where('(schedules.start_time between ? and ?) or schedules.end_time between ? and ?', *condi)
            ex= new_record? ? new_record_where.first : new_record_where.where("schedules.id<>?", self.id).first
            errors.add(:start_time, "冲突：老师#{teacher.name}在此时间段已经有排课") if ex
          end
        end
      end
    end
  end

  def self.base_query institution_id=nil
    if institution_id
      return joins(:sub_course => :institution).where(sub_courses: {institution_id: institution_id}).where(SubCourse.status_neq).select('institutions.name as institution_name,sub_courses.*,schedules.*')
    else
      return joins(:sub_course => :institution).where(SubCourse.status_neq).select('institutions.name as institution_name,sub_courses.*,schedules.*')
    end
  end

end
