class Achievement < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  attr_accessible :type, :parent_id
  
  belongs_to :parent, :class_name => "Achievement"
  has_many :sub_achievements, :class_name => "Achievement"
  has_many :achievementresults, :dependent=>:destroy

  def type? type
    self.type == type ? true : false
  end

  def self.achieves id,student_id
    joins(:achievementresults).where("id"=>id,"achievementresults.student_id" => student_id).select('achievementresults.*,achievements.name,achievements.type')
  end

  def self.achieve_types type,student_id
    joins(:achievementresults).where("type"=>type,"achievementresults.student_id" => student_id).select('achievements.name,achievements.type,achievements.id').uniq
  end

  def self.get_result_by_id id
    joins(:achievementresults).where("achievementresults.id"=>id).select('achievementresults.*,achievements.name,achievements.type')
  end
end
