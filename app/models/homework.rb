#encoding: utf-8
class Homework < ActiveRecord::Base
  belongs_to :teacher_course
  delegate :sub_course,:to=>:teacher_course
  has_many :attachments,:as=>:attachable
  has_one :student_homework,:dependent=>:destroy
  attr_accessible :content, :deadline, :title, :unmark_number
    acts_as_tenant(:tenant)
  def self.sub_total_unmark sub_course_id,teacher_id
    joins(:teacher_course).where(teacher_courses:{user_id:teacher_id,sub_course_id:sub_course_id}).sum(:unmark_number)
  end
end
