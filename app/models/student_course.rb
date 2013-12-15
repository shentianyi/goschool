#encoding: utf-8
class StudentCourse < ActiveRecord::Base
  belongs_to :student
  belongs_to :course
  belongs_to :tenant
  attr_accessible :paid, :status,:progress
  attr_accessible :student_id,:course_id
  validate :validate_save
  acts_as_tenant(:tenant)
 
  private
  def validate_save
    errors.add(:student_id,'学生已报名此课程') if self.class.where(:student_id=>self.student_id,:course_id=>self.course_id).first if new_record?
    errors.add(:user_id,'学生已报名此课程') if self.class.where(:student_id=>self.student_id,:course_id=>self.course_id).where('id<>?',self.id).first unless new_record?
  end

end
