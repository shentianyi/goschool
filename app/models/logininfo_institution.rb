# for lee 
# notice the model class name 
# by ws
class LogininfoInstitution < ActiveRecord::Base
  belongs_to :logininfo
  # attr_accessible :title, :body
  attr_accessible :institution_id,:logininfo_id
end
