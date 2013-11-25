class Student < ActiveRecord::Base
  attr_accessible :address, :birthday, :email, :gender, :graduation, :guardian, :guardian_phone, :name, :phone, :school,:referrer_id,:logininfo_id,:image_url
  has_one :referrer, :foreign_key => :referrer_id, :class_name => "Logininfo"
  has_one :Logininfo, dependent: :destroy
end
