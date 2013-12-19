#encoding: utf-8
class StudentHomework < ActiveRecord::Base
  belongs_to :student
  belongs_to :homework
  belongs_to :tenant
  has_many :attachments,:as=>:attachable,:dependent=>:destroy
  attr_accessible :content, :improved, :marked, :marked_time, :score, :submited_time,:homework_id
  acts_as_tenant(:tenant)

  validate :validate_save
  def self.detail_by_homework_id homework_id
    joins(:student).where(homework_id:homework_id).select("students.name, students.id as student_id,student_homeworks.*")
  end

  def self.by_type params
    if params[:menu_type].to_i==HomeworkStudentMenuType::UNSUBMIT
      student=Student.find_by_id(params[:student_id])
       student.original_homeworks.where(student_courses:{student_id:params[:student_id]}).where("homeworks.id not in (?)",StudentHomework.where(student_id:student.id).pluck(:homework_id))
    else
	    joins(:homework).joins(:student=>:student_courses)
	    .where(student_id:params[:student_id],student_courses:{course_id:params[:id]})
	    .where(HomeworkStudentMenuType.condition(params[:menu_type]))
	    .select("homeworks.*")
    end 
  end
  private

  def validate_save
    errors.add(:score,'作业分数不可为空') if self.score.blank?
  end
end
