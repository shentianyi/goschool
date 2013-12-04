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
        msg.result = true
        msg.content = @user
      end
    rescue ActiveRecord::RecordInvalid => invalid
      msg.result = false
      msg.content = invalid.record.errors
    end   
    render :json=>msg
  end

  def destroy
    msg = Msg.new
    msg.result = false
    msg.content = "删除失败"
    @user = User.find_by_id(params[:id])
    @logininfo = @user.logininfo
    if @logininfo && @logininfo.is_tenant
      msg.content = "不能删除创建者"
    elsif @logininfo.id == current_user.id
      msg.content = "不能删除自己"
    else
      @user.destroy
      msg.result = true
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
    @user = User.find_by_id(params[:id])
    @logininfo = @user.logininfo
    begin
      ActiveRecord::Base.transaction do
        #update user
        if params[:user]
          if @user.update_attributes(params[:user])
            if params[:user][:email]
              @logininfo.update_attributes!(:email=>params[:user][:email])
            end
            msg.result = true
          end
        end
        
        #update role
        if params[:logininfo_roles]
          @logininfo.logininfo_roles.destroy_all
          @roles = params[:logininfo_roles]
          @roles.each {| role |
            @new_role = LogininfoRole.new(:role_id=>role)
            @logininfo.logininfo_roles<<@new_role
          }
          @logininfo.save
          msg.result = true
        end
      end
    rescue ActiveRecord::RecordInvalid=>invalid
      msg.result = false
      msg.content = invalid.record.errors
    end
      render :json=>msg
  end
end
