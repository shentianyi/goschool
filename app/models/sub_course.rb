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
  attr_accessible :name, :parent_name,:course_id,:is_default,:institution_id
  
  acts_as_tenant(:tenant)


  redis_search_index(:title_field => :parent_name,
                     :condition_fields => [:tenant_id,:institution_id],
                     :ext_fields =>[:name,:is_default])
  # notice name blank validate !! default sub course
  def assign_teachers teachers
    teachers.each do |teacher|
      self.teacher_courses<<TeacherCourse.new(:user_id=>teacher[:teacher_id])
    end
  end
   
  private

  def del_default_sub_course
    self.course.sub_courses.where(:is_default=>true).destroy_all
  end

  def update_course_attr
    self.course.update_attributes(:has_sub=>true) unless self.is_default
  end
end
