# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  
  def index
    # need filter by ability
    @users = User.all
  end

  def new
    @user = User.new
  end
  
  def create
    msg = Message.new
    # create user and logininfo
    @user = User.new(params[:user])
    if @user.save
      msg.result = true
    else
      msg.resule = false
      msg.content = @user.errors
    end
    render :json=>msg
  end

  def destroy
    msg = Message.new
    @user = User.find(params[:user_id])
    if @user && !@user.logininfo.is_tenant
      msg.result = @user.destroy
    else
      msg.result = "用户不可删除！"
    end
    render :json=>msg
  end

  def edit
    @user = User.find_by_id(params[:user_id])
  end

  def update
    msg = Message.new
    if @user.update_attrbutes(params[:user])
      msg.result = true
      msg.content = @user.as_json
    else
      msg.result = false
      msg.content = @user.errors
    end 
    render :json=>msg
  end
end
