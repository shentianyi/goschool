class Student < ActiveRecord::Base
  attr_accessible :address, :birthday, :email, :gender, :graduation, :guardian, :guardian_phone, :name, :phone, :school,:referrer_id,:logininfo_id,:image_url
  
  belongs_to :logininfo

  has_one :referrer, :foreign_key => :referrer_id, :class_name => "Logininfo"
end
