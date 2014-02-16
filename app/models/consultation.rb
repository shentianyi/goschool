#encoding: utf-8
class Consultation < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :student_id,:logininfo_id,:consultants,:consult_time,:content

  belongs_to :student
  belongs_to :logininfo

  has_many :consultcomments, :dependent=>:destroy
end
