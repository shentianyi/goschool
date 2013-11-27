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
  attr_accessible :actual_number, :description, :end_date, :expect_number, :lesson, :name, :start_date, :type
  attr_accessible :has_sub,:status,:institution_id
  acts_as_tenant(:tenant)

  after_create :create_default_sub_course

  validate :validate_save

  redis_search_index(:title_field => :name,
                     :condition_fields => [:tenant_id])
                     
  def add_tags tags
    Resque.enqueue(TagAdder,self.tenant_id,self.class.name,self.id,tags)
  end

  def add_sub_courses sub_courses
    sub_courses.each do |sub|
      sub_course=SubCourse.new(:name=>sub[:name],:parent_name=>self.name)
      sub_course.assign_teachers(sub[:teachers]) if sub[:teachers]
      self.sub_courses<<sub_course
    end
    self.has_sub=true
  end

  def create_default_sub_course
    self.sub_courses.create(:parent_name=>self.name,:is_default=>true) unless self.has_sub
  end
  
  def course_students
    self.students.select('student_courses.*,student_courses.created_at as enrol_time,students.*').all
  end
  
  private

  def validate_save
    errors.add(:name,'课程名称不可为空') if self.name.blank?
  end

end
