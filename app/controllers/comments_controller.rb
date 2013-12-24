#encoding: utf-8
class CommentsController < ApplicationController
  skip_before_filter :require_user_as_employee
  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    msg = Msg.new
    msg.result = false
    @c = Comment.new(params[:comment])
    @c.logininfo = current_user
    if current_user.check_role(400)
      @c.is_teacher = true
    else
      @c.is_teacher = false
    end
    if @c.save
      @comment = CommentPresenter.new(@c)
      render partial: 'posts/comment'
    else
      msg.content = @c.errors.full_messages
      render :json=>msg
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    msg = Msg.new
    msg.result = false
    @comment = Comment.find(params[:id])
    @comment.destroy
    msg.result = true
    render :json=>msg
  end
end
