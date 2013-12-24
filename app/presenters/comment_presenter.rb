# -*- coding: utf-8 -*-
class CommentPresenter < Presenter
  def_delegators :@comment, :id,:post_id,:content,:is_teacher,:logininfo_id,:created_at,:updated_at

  def initialize(comment)
    @comment = comment
  end
  
  def commenter
    @logininfo = Logininfo.find(logininfo_id)
    if @logininfo.is_teacher?
      @logininfo.user
    else
      @logininfo.student
    end
  end

  def who_answer
    if is_teacher
      '导师回答'
    else
      nil
    end
  end

  def comment_time
    day = 3600*24
    midnight = Date.current.midnight.getlocal.to_i

    if ((diff=midnight - self.created_at.to_i) <= 0)
      #'今天 ' + self.created_at.getlocal.hour.to_s + ':'+self.created_at.getlocal.min.to_s
      self.created_at.getlocal.strftime('今天 %H:%M')
    elsif diff < 7*day
      "#{(diff/day).to_i}天前"
    elsif diff < 30*day
      "#{(diff/7/day).to_i}周前"
    else
      "#{self.created_at.strftime('%Y-%m-%d')}"
    end + "，"
  end

  def comment_time_string
    self.comment_time + '由' +self.commenter.name + '回答'
  end

  def to_json
    {
        comment:{
            id:self.id,
            content:self.content,
            comment_time:self.comment_time,
            commenter:self.commenter.to_json,
            is_teacher: self.who_answer ? true: false,
            who_answer: self.who_answer
        }
    }
  end
end
