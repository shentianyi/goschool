#encoding: utf-8
class CourcesController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_course,:only=>[:update,:show,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  
  def index
    render :json=> Cource.all
  end

  def show
    render :json=>@cource
  end

  def create
    @cource = current_tenant.courses.build(params[:course].strip)
    if @msg.result=@course.save
     @msg.content=@course.errors.messages
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
    @cource.destroy
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
