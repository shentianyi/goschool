#encoding: utf-8
class TeacherCourse < ActiveRecord::Base
  belongs_to :sub_course
  belongs_to :user
  belongs_to :teacher,:class_name=>'User',:foreign_key=>'user_id'
  delegate :course,:to=>:sub_course
  has_many :homeworks,:dependent=>:destroy
  attr_accessible :user_id,:sub_course_id

  validate :validate_save
  acts_as_tenant(:tenant)
  after_create :set_teacher_institution

  def self.by_teacher id,teacher_id
    where(id:id,user_id:teacher_id).first
  end

  def self.detail_by_teacher teacher_id
    joins(:sub_course=>:course).where(user_id:teacher_id).select("sub_courses.id as sub_course_id,sub_courses.name as sub_course_name,sub_courses.is_default,courses.id as course_id,courses.name as course_name,courses.*,teacher_courses.*")
  end


  private
  def validate_save
    errors.add(:user_id,'老师已登记此课程') if self.class.where(:user_id=>self.user_id,:sub_course_id=>self.sub_course_id).first if new_record?
    errors.add(:user_id,'老师已登记此课程') if self.class.where(:user_id=>self.user_id,:sub_course_id=>self.sub_course_id).where('id<>?',self.id).first unless new_record?
  end

  def set_teacher_institution
    User.add_institution(self.user_id,self.sub_course.institution_id)
  end
end
