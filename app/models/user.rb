# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name
  attr_accessible :email
  attr_accessible :image_url

  belongs_to :logininfo
  belongs_to :tenant
  
  has_many :teacher_courses,:dependent=>:destroy
  has_many :sub_courses,:through=>:teacher_courses
  has_many :courses,:through=>:sub_courses,:uniq => true
  has_many :schedules,:through=>:sub_courses
  has_many :logininfo_roles, :through=> :logininfo
  has_many :logininfo_institutions, :through=> :logininfo

  before_destroy :can_destroy?
  after_destroy :delete_related

  def delete_related
    @logininfo = self.logininfo
    puts 'after==========================='
    puts self.logininfo.id
    puts @logininfo.as_json
    @logininfo.destroy
  end

  def can_destroy?
    @loginifo = self.logininfo
    puts 'before==========================='
    puts @logininfo.as_json
    if @logininfo && @logininfo.is_tenant
      raise "不能删除创建人"
    end
  end
end
