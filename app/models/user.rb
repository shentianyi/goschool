class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name,:email
  
  has_one :logininfo, dependent: :destroy
  has_many :logininfo_roles, through: :logininfo

  #acts_as_authentic
end
