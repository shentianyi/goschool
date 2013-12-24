#encoding: utf-8
class CustomViewsController < ApplicationController
before_filter :init_message ,:only=>[:create,:destroy]
  before_filter :get_custom_view,:only=>:destroy
  before_filter :render_nil_msg , :only=>:destroy
  def create
    @custom_view = CustomView.new
    @custom_view.user=current_user.user
    @custom_view.name=params[:name]
    @custom_view.query = params[:q].to_json
    @custom_view.query_type=params[:query_type]
    @custom_view.entity_type = params[:entity_type]
    @msg.content=(@msg.result=@custom_view.save) ? @custom_view.id :  @custom_view.errors.messages
    render :json=>@msg
  end

  def destroy
    @custom_view.destroy
    @msg.result=true
    render :json=>@msg
  end

private

 def get_custom_view
    @custom_view=custom_view.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @custom_view
      @msg.content='不存在此视图'
      render :json=>@msg
    end
  end
end
