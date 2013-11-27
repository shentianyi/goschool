class Student < ActiveRecord::Base
  attr_accessible :address, :birthday, :email, :gender, :graduation, :guardian, :guardian_phone, :name, :phone, :school,:referrer_id,:logininfo_id,:image_url,:tenant_id
  
  belongs_to :logininfo
  belongs_to :tenant

  has_one :logininfo_role, :through=>:logininfo
  belongs_to :referrer, :foreign_key => :referrer_id, :class_name => "Logininfo"
end
