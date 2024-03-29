#encoding: utf-8
class TeacherCoursesController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_teacher_course , :only=>[:update,:show,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  
  def create
    @teacher_course = TeacherCourse.new(params[:teacher_course].strip)
   @msg.content=(@msg.result=@teacher_course.save) ? @teacher_course.id :  @teacher_course.errors.messages
    render :json=>@msg
  end

  def update
     @msg.content=@teacher_course.errors.messages unless @msg.result=@teacher_course.update_attributes(params[:teacher_course].strip)
    render :json=>@msg
  end

  def destroy
    @teacher_course.destroy
    @msg.result=true
    render :json=>@msg
  end
  

  private

  def get_teacher_course
    @teacher_course=TeacherCourse.find_by_id(params[:id].strip)
  end

  def render_nil_msg
    unless @teacher_course
      @msg.content='不存在此老师排课'
      render :json=>@msg
    end
  end
end
