# -*- coding: utf-8 -*-
class PostPresenter < Presenter
  def_delegators :@post,:id,:title,:content,:logininfo_id,:created_at,:updated_at

  def initialize(post)
    @post = post
  end

  def comments
    CommentPresenter.init_presenters(@post.comments.order("created_at DESC"))
  end
  
  def attachments
    @post.attachments
  end

  def post_time
    day = 3600*24
    midnight = Date.current.midnight.getlocal.to_i
    if ((diff=midnight - self.created_at.to_i) <= 0)
      #'今天 '+ self.created_at.getlocal.hour.to_s + ':'+self.created_at.getlocal.min.to_s
      self.created_at.strftime("今天 %H:%M")
    elsif diff < 7*day
      "#{(diff/day).to_i+1}天前"
    elsif diff < 30*day
      "#{(diff/7/day).to_i}周前"
    else
      "#{self.created_at.strftime('%Y-%m-%d')}"
    end + "，"
  end

  def poster
    @logininfo = Logininfo.find(logininfo_id)
    if @logininfo.is_teacher?
       @logininfo.user
    else
      @logininfo.student
    end
  end

  def post_time_string
    self.post_time + '由' +self.poster.name + '提出'
  end
end
