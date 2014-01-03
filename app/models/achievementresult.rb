#encoding: utf-8
class Achievementresult < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :student_id,:valuestring,:achievement_id,:achievetime

  belongs_to :achievement
  belongs_to :student

  def self.get_result_by_id id
    joins(:achievement).where("id"=>id).select('achievementresults.*,achievements.name,achievements.type')
  end
end
