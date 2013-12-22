# -*- coding: utf-8 -*-
class PostPresenter < Presenter
  def_delegators :@post,:id,:title,:content,:logininfo_id,:created_at,:updated_at

  def initialize(post)
    @post = post
  end

  def comments
    CommentPresenter.init_presenters(@post.comments)
  end
  
  def attachments
    @post.attachments
  end

  def post_time
    day = 3600*24
    if ((diff=Time.now.to_i - self.created_at.to_i) < day)
      self.created_at.getlocal.hour.to_s + ':'+self.created_at.getlocal.min.to_s+':'+self.created_at.getlocal.sec.to_s
    elsif diff < 7*day
      "#{(diff/day).to_i}天前"
    elsif diff < 30*day
      "#{(diff/7/day).to_i}周前"
    else
      "#{self.created_at.strftime('%Y-%m-%d')}"
    end + "，"
  end

  def poster
    @logininfo = Logininfo.find(logininfo_id)
    if @logininfo.is_teacher?
      self.post_time + '由' + @logininfo.user.name + '提出'
    else
      self.post_time + '由' + @logininfo.student.name + '提出'
    end
  end
end
