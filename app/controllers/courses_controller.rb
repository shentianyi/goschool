#encoding: utf-8
class CoursesController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_course,:only=>[:update,:show,:edit,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  def index
    render :json=> Course.all
  end

  def edit
    if @course
      @sub_courses=@course.sub_courses
    end
    render :json=>{:course=>@course,:sub_courses=>@sub_courses}
  end

  def create
    tags=params[:course].slice(:tags).strip
    subs=params[:course].slice(:subs).strip
    @course = current_tenant.courses.build(params[:course].except(:subs).except(:tags).strip)
    @course.add_sub_courses(subs[:subs]) if subs.size>0
    unless @msg.result=@course.save
    @msg.content=@course.errors.messages
    else
      @course.add_tags(tags[:tags]) if tags.size>0
    end
    render :json=>@msg
  end

  def update
    unless @msg.result=@course.update_attributes(params[:course].strip)
    @msg.content=@course.errors.messages
    end
    render :json=>@msg
  end

  def destroy
    @course.destroy
    @msg.result=true
    render :json=>@msg
  end

  private

  def init_message
    @msg=Msg.new
  end

  def get_course
    @course=Course.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @course
      @msg.content='不存在此课程'
      render :json=>msg
    end
  end
end
