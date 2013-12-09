class StudentHomework < ActiveRecord::Base
  belongs_to :student
  belongs_to :homework
  attr_accessible :content, :improved, :marked, :marked_time, :score, :submited_time
end
