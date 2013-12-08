# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name
  attr_accessible :email
  attr_accessible :image_url

  belongs_to :logininfo
  
  has_many :teacher_courses,:dependent=>:destroy
  has_many :sub_courses,:through=>:teacher_courses
  has_many :courses,:through=>:sub_courses,:uniq => true
  has_many :schedules,:through=>:sub_courses
  has_many :logininfo_roles, :through=> :logininfo
  has_many :logininfo_institutions, :through=> :logininfo
  
  validate :validate_save

  after_destroy :delete_related

  def delete_related
    @logininfo = self.logininfo
    @logininfo.destroy
  end
  
  #find all the teachers by institution_id
  def self.get_teachers institutions_id
    User.joins(:logininfo_institutions).joins(:logininfo_roles).where(logininfo_roles:{role_id:400},logininfo_institutions:{institution_id:institution_id}).all
  end

  #find all the employees by institution_id
  # take care of the method name.
  # test it after it was defined:)
  # def self.get_emplayees institution_id
    # User.joins(:logininfo_institutions).joins(:logininfo_roles).where(logininfo_roles:{role_id:[100,200]},logininfo_instutions:{institution_id:institution_id}).all
  # end
   def self.get_employees institution_id
    User.joins(:logininfo_institutions).joins(:logininfo_roles).where(logininfo_roles:{role_id:[100,200]},logininfo_institutions:{institution_id:institution_id}).all
  end

  private
    
  def validate_save
    errors.add(:name, '名字不能为空') if self.name.blank?
    errors.add(:email, '邮箱不能为空') if self.email.blank?
  end 
end
