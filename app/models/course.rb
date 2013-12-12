#encoding: utf-8
class Course < ActiveRecord::Base
  include Redis::Search
  self.inheritance_column = :_type_disabled
  belongs_to :user
  belongs_to :tenant
  belongs_to :institution
  has_many :sub_courses,:dependent=>:destroy
  has_many :schedules,:through=>:sub_courses
  has_many :student_courses,:dependent=>:destroy
  has_many :students,:through=> :student_courses
  has_many :teachers,:through=>:sub_courses
  attr_accessible :actual_number, :description, :end_date, :expect_number, :lesson, :name, :start_date, :type
  attr_accessible :has_sub,:status,:institution_id,:tenant_id,:code
  # for callback
  attr_accessor :tags,:subs,:teachs
  acts_as_tenant(:tenant)

  validate :validate_save

  redis_search_index(:title_field => :name,
                     :prefix_index_enable => true,
                     :alias_field=>:code,
                     :condition_fields => [:tenant_id,:institution_id],
                     :ext_fields=>[:has_sub])
  def create_default_sub_course
    unless self.has_sub
      sub_course= self.sub_courses.create(parent_name:self.name,is_default:true,institution_id:self.institution_id)
    sub_course.assign_teachers(self.teachs) if self.teachs
    end
  end

  def course_students
    self.students.select('student_courses.*,student_courses.created_at as enrol_time,students.*').all
  end

  def course_teachers
    self.teachers.select('users.*,sub_courses.id as sub_course_id,sub_courses.name as sub_course_name,sub_courses.parent_name as course_name').all
  end

  def teacher_details
    self.teachers.select('sub_courses.id as sub_course_id,sub_courses.name as sub_course_name,teacher_courses.id as teacher_course_id,users.*')
  end

  private

  def validate_save
    errors.add(:name,'课程名称不可为空') if self.name.blank?
    errors.add(:code,'课程代码不可重复') if self.class.where(code:self.code).first if new_record?
    errors.add(:code,'课程代码不可重复') if self.class.where('id<>? and code=?',self.id,self.code).first unless new_record?
  end

end
