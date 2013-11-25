class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name
  attr_accessible :email

  has_one :logininfo, dependent: :destroy
  has_many :teacher_courses,:dependent=>:destroy
  has_many :sub_courses,:through=>:teacher_courses
  has_many :courses,:through=>:sub_courses,:uniq => true
  has_many :logininfo_roles, through: :logininfo
  has_many :logininfo_institutions, through: :logininfo
  #acts_as_authentic
end
