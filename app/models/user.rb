class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name
  attr_accessible :email
  
  belongs_to :logininfo

  acts_as_authentic
end
