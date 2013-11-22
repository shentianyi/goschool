#encoding: utf-8
class SettingsController < ApplicationController
  before_filter :get_setting,:only=>[:index,:update]
  def index
    render :json=>@setting
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
