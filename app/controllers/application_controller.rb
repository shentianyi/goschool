#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  def current_tenant
    Tenant.first
  end
  rescue_from CanCan::AccessDenied do |exception|
    render :json=>{:access=>false},:status => 403
  end
end
