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
    msg = Msg.new
    # create user and logininfo
    begin
      ActiveRecord::Base.transaction do
        @logininfo = Logininfo.new(params[:logininfo])
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
    render @user.as_json
  end

  def destroy
    msg = Msg.new
    @user = User.find(params[:id])
    
    if @user && !@user.logininfo.is_tenant
      msg.result = true
    else
      msg.result = false
      msg.content = @user.errors
    end
    render :json=>msg
  end

  def edit
    @user = User.find_by_id(params[:id])
    render :json=>@user
  end

  def update
    msg = Msg.new
    @user = User.find_by_id(params[:id])
    if @user && @user.update_attributes(params[:user])
      msg.result = true
      msg.object = @user
    else
      msg.result = false
      msg.content = @user.errors
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
