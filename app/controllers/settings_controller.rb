#encoding: utf-8
class SettingsController < ApplicationController
  before_filter :get_setting,:only=>[:update]
  def index
    @institutions= current_tenant.institutions
  end

  def show
    case params[:id].strip
    when 'institutions'
      @institutions= current_tenant.institutions
      @partial='institutions'
    else
    @setting=current_tenant.setting
    @partial='settings'
    end
    render :partial=>@partial if params[:ajax]
  end

  def update
    msg=Msg.new
    unless msg.result=@setting.update_attributes(params[:setting].strip)
    msg.content=@setting.errors.messages
    end
    render :json=>msg
  end

  private

  def get_setting
    @setting=current_tenant.setting
  end
end
