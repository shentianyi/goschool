# -*- coding: utf-8 -*-
class UserSessionsController < ApplicationController
  skip_before_filter :require_user,:only=>[:new,:create]
  skip_before_filter :require_active_user,:only=>[:new,:create]
  #skip_before_filter :check_tenant_status
  #skip_defore_filter :find_cuurent_user_tenant,:only=>[:new,:create]
  
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
