#encoding: utf-8
class SchedulesController < ApplicationController
  before_filter :init_message ,:only=>[:show,:create,:update,:destroy,:dates,:courses,:teachers]
  before_filter :get_schedule,:only=>[:update,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  def index
    @active_left_aside='courses'
    @institutions=current_tenant.institutions
  end

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
    if params[:schedule].has_key?(:course_id)
      @course=Course.find_by_id(params[:schedule][:course_id])
      params[:schedule][:sub_course_id]=@course.sub_courses.first.id
    end
    @schedule=Schedule.new(params[:schedule].except(:course_id))
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
    @msg.content=SchedulePresenter.init_json_presenters( Schedule.between_date(params).all)
    render :json=>@msg
  end

  def teachers
    @msg.result=true
    params[:teacher_id]=session[:teacher_id] || params[:teacher_id]
    @msg.content=SchedulePresenter.init_json_presenters( Schedule.by_teacher_date(params).all)
    render :json=>@msg
  end

  def courses
    @msg.result=true
    @msg.content=SchedulePresenter.init_json_presenters( Schedule.by_course_id(params).all)
      render :json=>@msg 
  end

  def send_email
    @msg=Msg.new({result:true,content:'课表已发送'})
    begin
    EmailService.send_schedule_job(params[:type],params[:institution_id])
    rescue Exception=>e
      @msg.result=false
      @msg.content='课表发送失败，请联系服务商'
    end
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
