#encoding: utf-8
class CustomViewController < ApplicationController
before_filter :init_message ,:only=>[:create,:destroy]
  before_filter :get_custom_view,:only=>:destroy
  before_filter :render_nil_msg , :only=>:destroy
  def create
    @custom_view = CustomView.new(params[:custom_view])
    # custom.name=params[:name]
    # custom.query = params[:q].to_json
    # custom.query_type=params[:query_type]
    # custom.entity_type = params[:entity_type]
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
