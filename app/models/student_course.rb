#encoding: utf-8
class StudentCourse < ActiveRecord::Base
  belongs_to :student
  belongs_to :course
  belongs_to :tenant
  attr_accessible :paid, :status
  attr_accessible :student_id,:course_id
  validate :validate_save
  acts_as_tenant(:tenant)
  after_create :incr_course_stu_status
  after_destroy :decr_couse_stu_status

  private
  def validate_save
    errors.add(:student_id,'学生已报名此课程') if self.class.where(:student_id=>self.student_id,:course_id=>self.course_id).first if new_record?
    errors.add(:user_id,'学生已报名此课程') if self.class.where(:student_id=>self.student_id,:course_id=>self.course_id).where('id<>?',self.id).first unless new_record?
  end

  def incr_course_stu_status
    self.course.increment!(:actual_number)
    # self.student.update_attrubutes(:status=>KEHU)
  end

  def decr_couse_stu_status
   self.course.decrement!(:actual_number)
   # if student=self.student.courses.count==0
     # student.update_attributes(:status=>QIAN_ZAI_KE_HU)
   # end
  end
end
