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
  
  def create
    msg = Msg.new
    # create user and logininfo
    @user = User.new(params[:user])
    if @user.save
      msg.result = true
      msg.object = @user
    else
      msg.result = false
      msg.content = @user.errors
    end
    render :json=>msg
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
end
