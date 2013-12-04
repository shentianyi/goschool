#encoding: utf-8
class SchedulesController < ApplicationController
  before_filter :init_message ,:only=>[:show,:create,:update,:destroy,:dates,:courses]
  before_filter :get_schedule,:only=>[:update,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  def show
    if @schedule=Schedule.by_id(params[:id])
      @msg.result=true
      @msg.content=  SchedulePresenter.new(@schedule).to_json
    else
        @msg.content='不存在此课程表安排'
    end
    render :json=>@msg
  end

  def create
    @schedule=Schedule.new(params[:schedule].strip)
    @msg.content=(@msg.result=@schedule.save) ? @schedule.id :  @schedule.errors.messages
    render :json=>@msg
  end

  def update
    @msg.content=@schedule.errors.messages unless @msg.result=@schedule.update_attributes(params[:schedule].strip)
    render :json=>@msg
  end

  def destroy
    @schedule.destroy
    @msg.result=true
    render :json=>@msg
  end

  def dates
    @msg.result=true
    @msg.object=Schedule.between_date(params).collect{|schedule| SchedulePresenter.new(schedule).to_json}
    render :json=>@msg
  end

  def courses
    @msg.result=true
    @msg.object=Schedule.by_course_id(params).collect{|schedule| SchedulePresenter.new(schedule).to_json}
    render :json=>@msg
  end

  private

  def get_schedule
    @schedule=Schedule.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @schedule
      @msg.content='不存在此课程表安排'
      render :json=>@msg
    end
  end
end
