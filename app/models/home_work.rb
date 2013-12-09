#encoding: utf-8
class HomeWork < ActiveRecord::Base
  belongs_to :teacher_course
  attr_accessible :content, :deadline, :title
end
