class LogininfoRole < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :logininfo
  
  attr_accessible :role_id,:logininfo_id
end
