class Achievement < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  attr_accessible :achievementstring, :type, :student_id
  
  belongs_to :student
end
