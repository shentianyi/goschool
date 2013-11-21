#encoding: utf-8
class Tenant < ActiveRecord::Base
  attr_accessible :access_key, :company_name, :edition, :subscription_status,:domain

  has_one :setting,:dependent=>:destroy
  belongs_to :super_user ,:class_name=>'User',:foreign_key=>'user_id'
  
end
