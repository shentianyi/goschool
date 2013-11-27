#encoding: utf-8
class SchedulesController < ApplicationController
  before_filter :init_message ,:only=>[:show,:create,:update,:destroy,:dates,:courses]
  before_filter :get_schedule,:only=>[:show,:update,:destroy]
  before_filter :render_nil_msg , :only=>[:show,:update,:destroy]
  def show
    @msg.result=true
    @msg.object=SchedulePresenter.new(@schedule).to_json
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
    @schedules=Schedule.where(:start_time=>params[:start_date].strip..params[:end_date].strip).all
    @msg.object=SchedulePresenter.new(@schedules).to_jsons
    render :json=>@msg
  end

  def courses
    @msg.result=true
    type=params[:type].strip
    @schedules=if ['Course','SubCourse'].include?(type)
      type.constantize.find_by_id(params[:id]).schedules
    end
    @msg.object=SchedulePresenter.new(@schedules).to_jsons
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
