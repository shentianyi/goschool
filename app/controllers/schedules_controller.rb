#encoding: utf-8
class SchedulesController < ApplicationController
  before_filter :init_message ,:only=>[:show,:create,:update,:destroy]
  before_filter :get_schedule,:only=>[:show,:update,:destroy]
  before_filter :render_nil_msg , :only=>[:show,:update,:destroy]
  def show
    @msg.result=true
    @msg.object=SchedulePresenter.new(@schedule).to_json
    render :json=>@msg
  end

  def create
    @schedule=Schedule.new(params[:schedule].strip)
    unless @msg.result=@schedule.save
    @msg.content=@schedule.errors.messages
    end
    render :json=>@msg
  end

  def update
    unless @msg.result=@schedule.update_attributes(params[:schedule].strip)
    @msg.content=@schedule.errors.messages
    end
    render :json=>@msg
  end

  def destroy
    @schedule.destroy
    @msg.result=true
    render :json=>@msg
  end

  private

  def get_schedule
    @schedule=Schedule.find_by_id(params[:id].strip)
  end

  def render_nil_msg
    unless @schedule
      @msg.content='不存在此课程表安排'
      render :json=>msg
    end
  end
end
