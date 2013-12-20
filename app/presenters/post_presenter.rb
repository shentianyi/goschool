# -*- coding: utf-8 -*-
class PostPresenter < Presenter
  def_delegators :@post,:id,:title,:content,:logininfo_id,:created_at,:updated_at

  def initialize(post)
    @post = post
  end

  def comments
    @post.comments
  end

  def who_answer
    if is_teacher
      '导师回答'
    else
      ''
    end
  end

  def comment_time
    
  end
end
