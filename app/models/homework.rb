#encoding: utf-8
class Homework < ActiveRecord::Base
  belongs_to :teacher_course
  delegate :sub_course,:to=>:teacher_course
  has_many :attachments,:as=>:attachable,:dependent=>:destroy
  has_one :student_homework,:dependent=>:destroy
  attr_accessible :content, :deadline, :title, :unmark_number
    acts_as_tenant(:tenant)

    validate :validate_save

  def self.sub_total_unmark sub_course_id,teacher_id
    joins(:teacher_course).where(teacher_courses:{user_id:teacher_id,sub_course_id:sub_course_id}).sum(:unmark_number)
  end

  private 
  def validate_save
    errors.add(:title,'标题不可为空') if self.title.blank?
    errors.add(:deadline,'截止日期不可为空或格式不正确') if self.deadline.blank?   
    errors.add(:deadline,'截止日期不可小于当前日期') if !self.deadline.blank? && self.deadline<Date.today
  end
end
