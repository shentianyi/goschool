#encoding: utf-8
class Course < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  belongs_to :user
  belongs_to :tenant
  belongs_to :institution
  has_many :sub_courses,:dependent=>:destroy
  attr_accessible :actual_number, :description, :end_date, :expect_number, :lesson, :name, :start_date, :type
  attr_accessible :has_sub,:status,:institution_id
  acts_as_tenant(:tenant)

  after_create :create_default_sub_course

  validate :validate_save
  def add_tags tags
    Resque.enqueue(TagAdder,self.tenant_id,self.class.name,self.id,tags)
  end

  def add_sub_courses sub_courses
    sub_courses.each do |sub|
      self.sub_courses<<SubCourse.new(:name=>sub[:name],:parent_name=>self.name)
    end
    self.has_sub=true
  end

  def create_default_sub_course
    self.sub_courses.create(:parent_name=>self.name,:is_default=>true) unless self.has_sub
  end
  private

  def validate_save
    errors.add(:name,'课程名称不可为空') if self.name.blank?
  end

end
