# -*- coding: utf-8 -*-
class LogininfoSessionsController < ApplicationController
  before_filter :require_no_user,:only=>[:new,:create]
  skip_before_filter :require_user,:only=>[:new,:create]
  skip_before_filter :require_active_user,:only=>[:new,:create]
  #skip_before_filter :check_tenant_status
  skip_before_filter :find_current_user_tenant,:only=>[:new,:create]
  
  layout 'non_authorized'

  def new
    @user_session = LogininfoSession.new
  end

  def create
    @user_session = LogininfoSession.new(:email=>params[:email],:password=>params[:password])

    if @user_session.save
      flash[:notice] = "登录成功！"
      redirect_to root_url
    else
      flash[:notice] = "登录失败！"
      render :action => :new
    end    
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "注销成功！"
    redirect_to new_logininfo_sessions_url
  end
  
  def switch
    #if user
    redirect_to root_url
    #if teacher or student
    #redirect_to front_end_url
  end
end
