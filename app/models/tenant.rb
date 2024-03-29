#encoding: utf-8
class Tenant < ActiveRecord::Base
  has_one :setting,:dependent=>:destroy
  belongs_to :super_user ,:class_name=>'Logininfo',:foreign_key=>'logininfo_id'
  has_many :institutions,:dependent=>:destroy
  has_many :courses,:dependent=>:destroy
  has_many :logininfos, :dependent=>:destroy
  has_many :users, :through=>:logininfos
  has_many :students, :dependent=>:destroy
  attr_accessible :access_key, :company_name, :edition, :subscription_status,:domain,:logininfo_id

  validate :validate_save

  private
  def validate_save
    errors.add(:company_name,'公司名称不能为空') if self.company_name.blank?
  end
end
