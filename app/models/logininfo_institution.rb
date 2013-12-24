# for lee 
# notice the model class name 
# by ws
#encoding: utf-8
class LogininfoInstitution < ActiveRecord::Base
  belongs_to :logininfo
  belongs_to :institution
  # attr_accessible :title, :body
  attr_accessible :institution_id,:logininfo_id
end
