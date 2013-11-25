class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name
  attr_accessible :email

  belongs_to :logininfo
  has_many :teacher_courses,:dependent=>:destroy
  has_many :sub_courses,:through=>:teacher_courses
  has_many :courses,:through=>:sub_courses,:uniq => true
  acts_as_authentic
end
