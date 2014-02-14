#encoding: utf-8
class SettingsController < ApplicationController
  before_filter :require_user_as_admin

  def index
    @institutions= current_tenant.institutions
    @partial='institutions'
  end

  def show
    case params[:id]
      when 'institutions'
        @institutions= current_tenant.institutions
      when 'users'
        @users=current_tenant.users
      when 'materials'
        @materials=current_tenant.setting.materials
      else
        @setting=current_tenant.setting
        @partial='settings'
    end
    @partial||=params[:id]
    render :partial => @partial if params[:ajax]
  end

  def update
    msg=Msg.new
    @setting=current_tenant.setting
    msg.content=@setting.errors.messages unless msg.result=@setting.update_attributes(params[:setting].strip)
    render :json => msg
  end
end
