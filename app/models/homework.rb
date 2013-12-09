#encoding: utf-8
class Homework < ActiveRecord::Base
  belongs_to :teacher_course
  attr_accessible :content, :deadline, :title, :unmark_number
end
