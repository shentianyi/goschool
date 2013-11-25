#encoding: utf-8
class SchedulesController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_schedule,:only=>[:update,:show,:destroy]
  before_filter :render_nil_msg , :only=>[:show,:update,:destroy]
  
  def show
   @msg.result=true
   course=@schedule.sub_course
   @msg.object={:name=>course.parent_name,:sub_name=>course.name,}
   render :json=>@msg
  end
 
  def create
    @schedule = Schedule.new(params[:schedule])
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

  def get_shedule
    @schedule=Schedule.find_by_id(params[:id].strip)
  end

  def render_nil_msg
    unless @schedule
      @msg.content='不存在此课程表安排'
      render :json=>msg
    end
  end
end
