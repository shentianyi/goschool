#encoding: utf-8
class SettingsController < ApplicationController
  def index
    @institutions= current_tenant.institutions
    @logininfos = current_tenant.logininfos
  end

  def show
    case params[:id].strip
      when 'institutions'
        @institutions= current_tenant.institutions
        @partial='institutions'
      when 'users'
        @logininfos=current_tenant.logininfos
        @partial='users'
      else
        @setting=current_tenant.setting
        @partial='settings'
    end
    render :partial=>@partial if params[:ajax]
  end

  def update
    msg=Msg.new
    @setting=current_tenant.setting
    msg.content=@setting.errors.messages unless msg.result=@setting.update_attributes(params[:setting].strip)
    render :json=>msg
  end
end
