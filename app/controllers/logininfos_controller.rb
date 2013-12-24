#encoding: utf-8
class LogininfosController < ApplicationController
  #filter with ability
  #
  def index
    @logininfos = Logininfo.find_by_tenant_id(current_tenant.id)
    render :json=>@logininfos.as_json
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
  end

  def destroy
    
  end
end
