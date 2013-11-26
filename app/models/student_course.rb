class StudentCourse < ActiveRecord::Base
  belongs_to :student
  belongs_to :course
  attr_accessible :paid, :status
end
