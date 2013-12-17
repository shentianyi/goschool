class Achievementresult < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :student_id,:valuestring,:achievement_id

  belongs_to :achievement, :dependent=>:destroy
  belongs_to :student, :dependent=>:destroy
end
