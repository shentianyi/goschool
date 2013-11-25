#encoding: utf-8
class Schedule < ActiveRecord::Base
  belongs_to :sub_course
  attr_accessible :end_time, :start_time
end
