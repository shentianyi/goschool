#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :find_current_user_tenant
  set_current_tenant_through_filter
  def find_current_user_tenant
    current_tenant=Tenant.first
    set_current_tenant(current_tenant)
  end

  rescue_from CanCan::AccessDenied do |exception|
    render :json=>{:access=>false},:status => 403
  end

  def init_message
    @msg=Msg.new
  end
end
