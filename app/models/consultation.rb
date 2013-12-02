class Consultation < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :student_id,:logininfo_id,:consultants,:consult_time,:content,:comment,:comment_time,:commenter

  belongs_to :student
  belongs_to :logininfo
end
