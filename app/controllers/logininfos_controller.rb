#encoding: utf-8
class LogininfosController < ApplicationController
  skip_before_filter :require_user_as_employee, :only => [:index,:update]
  #filter with ability
  #
  def index
    #@logininfos = Logininfo.find_by_tenant_id(current_tenant.id)
    #render :json=>@logininfos.as_json
    @user = current_logininfo.user
  end

  def new
    @logininfo = Logininfo.new
    render :json=>"new"
  end

  #create logininfo at the same time
  def create
   
  end
  
  def edit
    @logininfo = User.find_by_id(params[:id])
    render :as_json=>@user
  end
  
  def update
    msg = Msg.new
    @logininfo = current_logininfo
    @user = current_logininfo.user

    if params.has_key?(:password)
      @logininfo.password = params[:password]
      @logininfo.password_confirmation = params[:password]
    end
    if params.has_key?(:email)
      @logininfo.email = params[:email]
      @user.email = params[:email]
    end

    if @logininfo.changed? && @logininfo.save
      msg.result = true
    else
      msg.result = false
      msg.content = @logininfo.errors
    end

    if @user.changed? && @user.save

    end

    render :json=>msg
  end

  def destroy
    
  end
end
