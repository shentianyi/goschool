#encoding: utf-8
class SettingsController < ApplicationController
  def index
    @institutions= current_tenant.institutions
  end

  def show
    case params[:id]
      when 'institutions'
        @institutions= current_tenant.institutions
      when 'users'
        @logininfos=current_tenant.logininfos
      else
        @setting=current_tenant.setting
        @partial='settings'
    end
    @partial||=params[:id]
    render :partial=>@partial if params[:ajax]
  end

  def update
    msg=Msg.new
    @setting=current_tenant.setting
    msg.content=@setting.errors.messages unless msg.result=@setting.update_attributes(params[:setting].strip)
    render :json=>msg
  end
end
