#encoding: utf-8
class SubCourse < ActiveRecord::Base
  include Redis::Search
  belongs_to :course
  belongs_to :tenant
  belongs_to :institution
  has_many :teacher_courses,:dependent=>:destroy
  has_many :schedules,:dependent=>:destroy
  has_many :teachers,:through=>:teacher_courses,:class_name=>'User'
  has_many :homeworks,:through=>:teacher_courses
  attr_accessible :name, :parent_name,:course_id,:is_default,:institution_id,:is_base

  acts_as_tenant(:tenant)

  redis_search_index(:title_field => :parent_name,
                     :prefix_index_enable => true,
                     :condition_fields => [:tenant_id,:institution_id],
                     :ext_fields =>[:name,:is_default])
  # notice name blank validate !! default sub course
  #
  validate :validate_save
  def assign_teachers teachers
    teachers.uniq.each do |teacher|
      self.teacher_courses<<TeacherCourse.new(:user_id=>teacher[:id]) unless teacher[:id].blank?
    end
  end

  def teacher_names
    self.teachers.map{|t| t.name}
  end

  def  teacher_details
    self.teachers.select('teacher_courses.id as teacher_course_id,users.*')
  end
  
  def self.status_neq status=CourseStatus::FINISHED
    SubCourse.arel_table[:status].not_eq(status)
  end
  
  private

  def del_default_sub_course
    self.course.sub_courses.where(:is_default=>true).destroy_all
  end

  def update_course_attr
    self.course.update_attributes(:has_sub=>true) unless self.is_default
  end

  def validate_save
    unless self.is_default
      errors.add(:name,'子课程名称不可为空') if self.name.blank?
      errors.add(:name,'子课程名称不可重复') if self.class.where(name:self.name,course_id:self.course_id).first if new_record?
      errors.add(:code,'子课程代码不可重复') if self.class.where('id<>? and name=? and course_id=?',self.id,self.name,self.course_id).first unless new_record?
    end
  end
end
