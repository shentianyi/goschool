# -*- coding: utf-8 -*-
class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    
    if @user_session.save
      flash[:notice] = "登录成功！"
      redirect_to root_path
    else
      flash[:notice] = "登录失败！"
      render :action => :new
    end    
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "注销成功！"
    redirect_to new_user_session_url
  end
end
