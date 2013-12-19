# -*- coding: utf-8 -*-
class LogininfoSessionsController < ApplicationController
  before_filter :require_no_user,:only=>[:new,:create]
  skip_before_filter :require_user_as_employee,:only=>[:new,:create,:destroy]
  skip_before_filter :require_user,:only=>[:new,:create]
  skip_before_filter :require_active_user,:only=>[:new,:create]
  #skip_before_filter :check_tenant_status
  skip_before_filter :find_current_user_tenant,:only=>[:new,:create]
  skip_authorize_resource :only=>[:new,:create]
  
  layout 'non_authorized'

  def new
    @user_session = LogininfoSession.new
  end

  def create
    @user_session = LogininfoSession.new(:email=>params[:email],:password=>params[:password])

    if @user_session.save
      switch @user_session.record
      #flash[:notice] = "登录成功！"
      #redirect_to root_url
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
  
  def switch user
    if user.is_employee?
      redirect_to root_path
    elsif user.is_student?
      redirect_to student_index_path
    elsif user.is_teacher?
      redirect_to teachers_index_path
    end
  end
end
