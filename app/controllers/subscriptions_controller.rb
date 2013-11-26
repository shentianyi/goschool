# -*- coding: utf-8 -*-
class SubscriptionsController < ApplicationController
  skip_before_filter :require_user,:only=>[:new,:create]
  skip_before_filter :require_active_user,:only => [:new,:create]
  skip_before_filter :find_current_user_tenant,:only=>[:new,:create]
  before_filter :require_no_user :only=>[:new,:create]
  before_filter :is_sign_up_allowed, :only=>[:new,:create]
  
  def new
    
  end

  def is_sign_up_allowed
    if !$open_signup
      flash[:notice]="我们还没有开放注册"
      render "errors/500"
    else
      return true
    end
  end

  def create
    begin
      @user=User.new(params[:name],params[:email])
      @logininfo = Logininfo.new
      @logininfo = @logininfo.create_tenant_user!(params[:email],
                                                  params[:password],
                                                  params[:password_confirmation],
                                                  params[:company_name])
      if @logininfo.save
        @user.logininfo_id = @logininfo.id
        flash[:notice] = '注册成功！'
        redirect_to new_user_session_url
      else
        flash[:notice] = '注册失败！'
        redirect_to new_user_session_url
      end
    end
  end
end
