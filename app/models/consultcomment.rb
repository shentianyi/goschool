#encoding: utf-8
class Consultcomment < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :comment,:comment_time,:logininfo_id,:consultation_id

  belongs_to :logininfo
  belongs_to :consultation
end
