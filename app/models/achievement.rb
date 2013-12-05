class Achievement < ActiveRecord::Base
	self.inheritance_column = :_type_disabled
  	attr_accessible :achievementstring, :type
end
