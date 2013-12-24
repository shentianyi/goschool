#encoding: utf-8
class StudentHomework < ActiveRecord::Base
  belongs_to :student
  belongs_to :homework
  belongs_to :tenant
  has_many :attachments,:as=>:attachable,:dependent=>:destroy
  attr_accessible :content, :improved, :marked, :marked_time, :score, :submited_time,:homework_id
  acts_as_tenant(:tenant)

  validate :validate_save
  def self.detail_by_homework_id homework_id,student_id=nil
    q=joins(:student).where(homework_id:homework_id).select("students.id as student_id,students.*,student_homeworks.*")
    q=q.where(student_id:student_id) if student_id
    q
  end
  
  def self.unsubmits  student_id
     student=Student.find_by_id(student_id)
      ids=StudentHomework.where(student_id:student.id).pluck(:homework_id)
      q= student.original_homeworks.where(student_courses:{student_id:student_id})
       q=q.where("homeworks.id not in (?)",ids) if ids.count>0
       q.select('sub_courses.name as sub_course_name,sub_courses.parent_name as course_name,homeworks.*')
  end

  def self.by_type params
   if params[:menu_type].to_i==HomeworkStudentMenuType::UNSUBMIT
      student=Student.find_by_id(params[:student_id])
      ids=StudentHomework.where(student_id:student.id).pluck(:homework_id)
      q= student.original_homeworks.where(student_courses:{student_id:params[:student_id],course_id:params[:id]})
       q=q.where("homeworks.id not in (?)",ids) if ids.count>0
    else
	   q=  joins(:homework=>{:teacher_course=>:sub_course}).joins(:student)
	    .where(student_id:params[:student_id],sub_courses:{course_id:params[:id]})
	    .where(HomeworkStudentMenuType.condition(params[:menu_type]))
	    .select("homeworks.*")
    end
     q=q.where(sub_courses:{id:params[:sub_course_id]}) if params[:sub_course_id]
     q
  end
  
    def  can_resubmit?
      !self.marked
    end
    
  private

  def validate_save
    errors.add(:score,'作业分数不可为空') if self.score.blank? && !self.score.nil? unless self.new_record?
  end
end
