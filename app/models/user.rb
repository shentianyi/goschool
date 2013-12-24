#encoding: utf-8
class User < ActiveRecord::Base
  # attr_accessible :title, :body
  include Redis::Search
  attr_accessible :name
  attr_accessible :email
  attr_accessible :image_url,:is_teacher,:tenant_id

  belongs_to :logininfo
  belongs_to :tenant
  
  has_many :teacher_courses,:dependent=>:destroy
  has_many :sub_courses,:through=>:teacher_courses
  has_many :courses,:through=>:sub_courses,:uniq => true
  has_many :schedules,:through=>:sub_courses
  has_many :logininfo_roles, :through=> :logininfo
  has_many :logininfo_institutions, :through=> :logininfo
  has_many :custom_views
  validate :validate_save

  after_destroy :delete_related
  
  acts_as_tenant(:tenant)

  redis_search_index(:title_field => :name,
                     :condition_fields => [:tenant_id,:is_teacher],
                     :prefix_index_enable => true,
                     :alias_field=>:email,
                     :ext_fields=>[:email,:name,:is_teacher])

  def delete_related
    @logininfo = self.logininfo
    @logininfo.destroy
  end
  
  def self.add_institution teacher_id,institution_id
    @user = User.find(teacher_id)
    @institution = Institution.find(institution_id)
    if !@user || !@institution
      return false
    end

    if @user.in_institution? institution_id
      return false
    end
    
    l_institution = LogininfoInstitution.new(:institution_id=>institution_id,:logininfo_id=>@user.logininfo_id)
    puts l_institution.to_json
    @logininfo = @user.logininfo
    @logininfo.logininfo_institutions<<l_institution
    return true
  end
  
  def in_institution? institution_id
    self.logininfo_institutions.find_by_institution_id(institution_id)
  end

  #find all the teachers by institution_id
  def self.get_teachers institution_id
    User.joins(:logininfo_roles).where(logininfo_roles:{role_id:400}).all
    #User.joins(:logininfo_institutions).joins(:logininfo_roles).where(logininfo_roles:{role_id:400},logininfo_institutions:{institution_id:institution_id}).all
  end

  #find all the employees by institution_id
  # take care of the method name.
  # test it after it was defined:)
  # def self.get_emplayees institution_id
  # User.joins(:logininfo_institutions).joins(:logininfo_roles).where(logininfo_roles:{role_id:[100,200]},logininfo_instutions:{institution_id:institution_id}).all
  # end
  def self.get_employees institution_id
    User.joins(:logininfo_roles).where(logininfo_roles:{role_id:[100,200]}).all
    #User.joins(:logininfo_institutions).joins(:logininfo_roles).where(logininfo_roles:{role_id:[100,200]},logininfo_institutions:{institution_id:institution_id}).all
  end


  def self.by_course_id course_id
    joins(:courses).where(courses:{id:course_id}).uniq
  end
  
  private
  
  def validate_save
    errors.add(:name, '名字不能为空') if self.name.blank?
    errors.add(:email, '邮箱不能为空') if self.email.blank?
  end 

  
end
