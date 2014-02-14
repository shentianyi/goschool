#encoding: utf-8
class Setting < ActiveRecord::Base
  belongs_to :tenant
  attr_accessible :default_pwd
  has_many :materials,:as=>:materialable

  acts_as_tenant(:tenant)

  validates_presence_of :default_pwd,:message=>'默认不可为空'
end
