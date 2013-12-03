# -*- coding: utf-8 -*-
class Comment < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :post_id, :is_teacher, :logininfo_id, :content
  
  validate :validate_save

  belongs_to :post
  belongs_to :logininfo

  def validate_save
    errors.add(:content, '评论内容不能为空') if self.content.blank?
  end
end
