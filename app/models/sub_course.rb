#encoding: utf-8
class SubCourse < ActiveRecord::Base
  belongs_to :course
  has_many :teacher_courses,:dependent=>:destroy
  has_many :teachers,:through=>:teacher_courses,:class_name=>'User'
  attr_accessible :name, :parent_name,:course_id,:is_default

  before_create :del_default_sub_course
  after_create :update_course_attr
  after_destroy :create_default_sub_course
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

  def create_default_sub_course
    course=self.course
    if course.sub_courses.count==0
      course.update_attributes(:has_sub=>false)
    course.create_default_sub_course
    end
  end
end
