class Achievementresult < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :student_id,:valuestring,:achievement_id

  belongs_to :achievement
  belongs_to :studentx
end
