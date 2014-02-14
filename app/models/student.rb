#encoding: utf-8
class Student < ActiveRecord::Base
  include Redis::Search

  attr_accessible :address, :birthday, :email, :gender, :graduation, :guardian, :guardian_phone, :name, :phone, :school,:referrer_id,:logininfo_id,:image_url,:tenant_id
  attr_accessible :student_status,:course_number, :remark

  attr_accessor :tags

  belongs_to :logininfo
  belongs_to :referrer, :foreign_key => :referrer_id, :class_name => "Logininfo"
  belongs_to :tenant

  has_one :logininfo_role, :through=>:logininfo
  has_many :consultations, :dependent=>:destroy
  has_many :student_courses
  has_many :courses,:through=>:student_courses
  has_many :achievementresults, :dependent=>:destroy
  has_many :student_homeworks
  has_many :homeworks,:through=>:student_homeworks
  has_many :sub_courses,:through=>:courses
  has_many :original_homeworks,:source=>'homeworks',:through=>:sub_courses

  after_destroy :delete_related

  acts_as_tenant(:tenant)

  validate :validate_save

  redis_search_index(:title_field =>:name,
                     :condition_fields => [:tenant_id],
                     :prefix_index_enable => true,
                     :alias_field=>:email,
                     :ext_fields=>[:email,:address,:school,:guardian,:logininfo_id])
  def delete_related
    @logininfo = self.logininfo
    @logininfo.destroy
  end

  def is_male?
    self.gender == 1 ? true : false
  end

  def is_actived?
    self.logininfo.status == UserStatus::ACTIVE ? true : false
  end

  def self.course_detail id
    joins(:courses).where(:id=>id).select('student_courses.id as student_course_id,student_courses.progress,student_courses.paid,courses.*,courses.id as course_id')
  end
  
  def self.by_id id 
    where(:id=>id)
  end

  def add_tags
    TagService.add_tags(self)  if self.tags
  end

  def validate_save
    errors.add(:name,'名字不能为空') if self.name.blank?
    #errors.add(:phone, '电话不能为空') if self.phone.blank?
    #errors.add(:guardian, '监护人不能为空') if self.guardian.blank?
    #errors.add(:guardian_phone, '监护人号码不能为空') if self.guardian_phone.blank?
    #errors.add(:email, 'email bunengweikong') if self.email.blank?
  end

  after_save ThinkingSphinx::RealTime.callback_for(:student)
end
