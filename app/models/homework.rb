#encoding: utf-8
class Homework < ActiveRecord::Base
  belongs_to :teacher_course
  delegate :sub_course,:to=>:teacher_course
  has_many :attachments,:as=>:attachable,:dependent=>:destroy
  has_many :student_homeworks,:dependent=>:destroy
  attr_accessible :content, :deadline, :title, :unmark_number,:teacher_course_id,:status
    acts_as_tenant(:tenant)

    validate :validate_save

  def self.sub_total_unmark sub_course_id,teacher_id
    joins(:teacher_course).where(teacher_courses:{user_id:teacher_id,sub_course_id:sub_course_id}).sum(:unmark_number)
  end

  def self.by_homework_type params
    case params[:homework_type]
    when HomeworkType::TEACHER
	where(teacher_course_id:params[:id]).where(HomeworkTeacherMenuType.condition(params[:menu_type])).all
    when HomeworkType::Stuent
      []
    else
      []
    end
  end
  private 
  def validate_save
    errors.add(:title,'标题不可为空') if self.title.blank?
    errors.add(:deadline,'截止日期不可为空或格式不正确') if self.deadline.blank?   
    errors.add(:deadline,'截止日期不可小于当前日期') if !self.deadline.blank? && self.deadline<Date.today
  end
end
