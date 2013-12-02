#encoding: utf-8
class Course < ActiveRecord::Base
  include Redis::Search
  self.inheritance_column = :_type_disabled
  belongs_to :user
  belongs_to :tenant
  belongs_to :institution
  has_many :sub_courses,:dependent=>:destroy
  has_many :schedules,:through=>:sub_courses
  has_many :student_courses,:dependent=>:destroy
  has_many :students,:through=> :student_courses
  has_many :teachers,:through=>:sub_courses
  attr_accessible :actual_number, :description, :end_date, :expect_number, :lesson, :name, :start_date, :type
  attr_accessible :has_sub,:status,:institution_id,:tenant_id
  # for callback
  attr_accessor :tags,:subs
  acts_as_tenant(:tenant)

  validate :validate_save

  redis_search_index(:title_field => :name,
                     :condition_fields => [:tenant_id,:institution_id])

  def create_default_sub_course
    self.sub_courses.create(:parent_name=>self.name,:is_default=>true) unless self.has_sub
  end

  def course_students
    self.students.select('student_courses.*,student_courses.created_at as enrol_time,students.*').all
  end

  def course_teachers
    self.teachers.select('sub_courses.id as sub_course_id,sub_courses.name as sub_courses_name,sub_courses.parent_name as course_name')
  end

  private

  def validate_save
    errors.add(:name,'课程名称不可为空') if self.name.blank?
  end

end
