# -*- coding: utf-8 -*-
class SubscriptionsController < ApplicationController
  skip_before_filter :require_user,:only=>[:new,:create]
  skip_before_filter :require_active_user,:only => [:new,:create]
  skip_before_filter :find_current_user_tenant,:only=>[:new,:create]
  skip_authorize_resource :only=>[:new,:create]
  before_filter :require_no_user, :only=>[:new,:create]
  #before_filter :is_sign_up_allowed, :only=>[:new,:create]
  
  def new
    
  end

  def is_sign_up_allowed

  end

  def create
    begin
      raise(ArgumentError, 'Email 已被使用！')  if $invalid_emails.include?(params[:email])
      @user=User.new(:name=>params[:name],:email=>params[:email])
      @logininfo = Logininfo.new
      @logininfo = @logininfo.create_tenant_user!(params[:email],
                                                  params[:password],
                                                  params[:password_confirmation],
                                                  params[:company_name])
      #@logininfo.deliver_logininfo_confirmation
      puts "Create"
      if @logininfo
        @user.logininfo_id = @logininfo.id
        if @user.save
          flash[:notice] = '注册成功！'
          redirect_to new_logininfo_session_url
        end
      else
        flash[:notice] = '注册失败！'
        render 'new'
      end
    rescue ArgumentError=>invalid
      flash[:notice]='Email已被使用！'
      render 'new'
    rescue ActiveRecord::RecordInvalid=> invalid
      flash[:notice]='注册失败！'
      render 'new'
    end
  end
end
