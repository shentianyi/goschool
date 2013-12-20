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
    @comment = Comment.new(params[:comment])
    @comment.logininfo = current_user
    if current_user.check_role(400)
      @comment.is_teacher = true
    else
      @comment.is_teacher = false
    end
    if @comment.save
      msg.result = true
      msg.content = @comment
    end
    
    render :json=>msg
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
