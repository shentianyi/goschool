# -*- coding: utf-8 -*-
class ConsultcommentsController < ApplicationController
  def create
    msg = Msg.new
    msg.result = false
    msg.content = '创建咨询评论失败'
    @consultcomment = Consultcomment.new(params[:consultcomment])
    @consultcomment.logininfo = current_user
    
    msg.result = @consultcomment.save
    msg.object = ConsultcommentPresenter.new(@consultcomment).to_json
    
    render :json=>msg
  end

  def destroy
    msg = Msg.new
    msg.result = false
    msg.content = '删除咨询评论失败'
    @comment = Consultcomment.find(params[:id])
    @comment.destroy
    msg.result = true
    render :json=>msg
  end
end
