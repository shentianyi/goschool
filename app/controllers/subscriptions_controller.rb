# -*- coding: utf-8 -*-
class SubscriptionsController < ApplicationController
  skip_before_filter :require_user,:only=>[:new,:create]
  skip_before_filter :require_active_user,:only => [:new,:create]
  skip_before_filter :require_user_as_employee, :only => [:new,:create]
  skip_before_filter :find_current_user_tenant,:only=>[:new,:create]
  skip_load_and_authorize_resource
  before_filter :require_no_user, :only=>[:new,:create]
  #before_filter :is_sign_up_allowed, :only=>[:new,:create]
  
  layout "non_authorized"
  def new
    
  end

  def is_sign_up_allowed

  end

  def create
    begin
      #raise(ArgumentError, 'Email 已被使用！')  if $invalid_emails.include?(params[:email])
      msg = Msg.new
      msg.result = false
      @user=User.new(:name=>params[:name],:email=>params[:email])
      @logininfo = Logininfo.new
      @logininfo = @logininfo.create_tenant_user!(params[:email],
                                                  params[:password],
                                                  params[:password_confirmation],
                                                  params[:company_name])
      #@logininfo.deliver_logininfo_confirmation
      if @logininfo
        @user.logininfo_id = @logininfo.id
        @user.tenant = @logininfo.tenant
        if msg.result = @user.save
        else
          msg.content = @user.errors
        end
      else
        #flash[:notice] = '注册失败！'
        msg.content = '注册失败！'
      end
    rescue ArgumentError=>invalid
      msg.content = invalid.record.errors.full_messages
    rescue ActiveRecord::RecordInvalid=> invalid
      msg.content = invalid.record.errors.full_messages
    end
    render :json=>msg
  end
end
