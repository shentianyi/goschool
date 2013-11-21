class Setting < ActiveRecord::Base
  attr_accessible :default_pwd
  
  belongs_to :tenant
  
  acts_as_tenant(:tenant)
end
