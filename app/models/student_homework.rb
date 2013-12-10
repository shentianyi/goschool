#encoding: utf-8
class StudentHomework < ActiveRecord::Base
  belongs_to :student
  belongs_to :homework
  belongs_to :tenant
  attr_accessible :content, :improved, :marked, :marked_time, :score, :submited_time
  acts_as_tenant(:tenant)
end
