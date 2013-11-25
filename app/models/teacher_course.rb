#encoding: utf-8
class TeacherCourse < ActiveRecord::Base
  belongs_to :sub_course
  belongs_to :user
  belongs_to :teacher,:class_name=>'User',:foreign_key=>'user_id'
  attr_accessible :user_id,:sub_course_id

  validate :validate_save

  private
  def validate_save
    errors.add(:user_id,'老师已登记此课程') if self.class.where(:user_id=>self.user_id,:sub_course_id=>self.sub_course_id).first if new_record?
     errors.add(:user_id,'老师已登记此课程') if self.class.where(:user_id=>self.user_id,:sub_course_id=>self.sub_course_id).where('id<>?',self.id).first unless new_record?
  end
end
