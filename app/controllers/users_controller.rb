# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  #filter with ability [index,create,destroy,update,edit]
  def index
    @users = User.all
    render :json=>@users.as_json
  end

  def new
    @user = User.new
    render :json=>"new"
  end
  
  #create user,loginifo
  def create
    # create user and logininfo
    msg = Msg.new
    msg.result = false
    begin
      ActiveRecord::Base.transaction do
        @logininfo = Logininfo.new(:email=>params[:user][:email],:password=>current_tenant.setting.default_pwd,:password_confirmation=>current_tenant.setting.default_pwd)
        @logininfo.tenant = current_tenant
        @logininfo.status = UserStatus::ACTIVE
        
        @roles = params[:logininfo_roles]
        @roles.each {|role|
          @new_role = LogininfoRole.new(:role_id=>role)
          @logininfo.logininfo_roles<<@new_role
        }

        @logininfo.save!
        @user = User.new(params[:user])
        @user.logininfo = @logininfo
        @user.save!
      end
    end
    msg.result = true
    msg.content = @user
    render :json=>msg
  end

  def destroy
    msg = Msg.new
    msg.result = false
    msg.content = "删除失败"
    @logininfo = Logininfo.find_by_id(params[:id])
    if @logininfo && !@logininfo.is_tenant
      msg.result = true
      @logininfo.destroy
    elsif @logininfo && @logininfo.is_tenant
      msg.content = "不能删除管理员"
    end
    render :json=>msg
  end

  def edit
    @user = User.find_by_id(params[:id])
    render :json=>@user
  end

  def update
    msg = Msg.new
    msg.result = false
    @logininfo = Logininfo.find_by_id(params[:id])
    @user = @logininfo.user
    
    #update user
    if params[:user]
      if @user.update_attributes(params[:user])
        if params[:user][:email]
          puts '=============='
          puts params[:user][:email]
          @logininfo.update_attributes!(:email=>params[:user][:email])
        end
        msg.result = true
      end
    end

    #update role
    if params[:logininfo_roles]
      @logiinfo.logininfo_roles.destroy
      @roles = params[:logininfo_roles]
      @roles.each {| role |
        @role = LogininfoRole.new(role)
        @logininfo.logininfo_roles<<@role
      }
      @logininfo.update!
    end
    
    render :json=>msg
  end

  def get_user
    msg = Msg.new
    msg.result = false
    @user = User.find_by_id(params[:id])
    if @user
      msg.result = true
      msg.object = @user.as_json 
    end
   
    render :json=>msg
  end
end
