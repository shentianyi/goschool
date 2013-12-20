# -*- coding: utf-8 -*-
class CommentPresenter < Presenter
  def_delegators :@comment, :id,:post_id,:content,:is_teacher,:logininfo_id,:created_at,:updated_at

  def initialize(comment)
    @comment = comment
  end
  
  def commenter
    @logininfo = Logininfo.find(logininfo_id)
    if @logininfo.is_teacher?
      self.comment_time + '由' + @logininfo.user.name + '回答'
    else
      self.comment_time + '由' + @logininfo.student.name + '回答'
    end
  end

  def who_answer
    if is_teacher
      '导师回答'
    else
      ''
    end
  end

  def comment_time
    day = 3600*24
    if ((diff=Time.now.to_i - self.created_at.to_i) < day)
      self.created_at.hour.to_s + ':'+self.created_at.min.to_s+':'+self.created_at.sec.to_s
    elsif diff < 7*day
      "#{(diff/day).to_i}天前"
    elsif diff < 30*day
      "#{(diff/7/day).to_i}周前"
    else
      "#{self.created_at.strftime('%Y-%m-%d')}"
    end + "，"
  end
end
