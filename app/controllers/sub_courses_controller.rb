#encoding: utf-8
class SubCoursesController < ApplicationController
 
  before_filter :init_message ,:only=>[:create,:update,:destroy,:teachers]
  before_filter :get_sub_course,:only=>[:update,:edit,:destroy,:teachers]
  before_filter :render_nil_msg , :only=>[:update,:destroy,:teachers]
  def create
    if @course=Course.find_by_id(params[:course_id].strip)
      @sub_course = @course.sub_courses.build(params[:sub_course].strip)
     @msg.content=(@msg.result=@sub_course.save) ? @sub_course.id :  @sub_course.errors.messages
    else
      @msg.content='课程不存在，无法添加内容'
    end
    render json:@msg
  end
 
  def update
    unless @msg.result=@sub_course.update_attributes(params[:sub_course].strip)
     @msg.content=@sub_course.errors.messages
    end
    render json:@msg    
  end

  def destroy
      @sub_course.destroy
      @msg.result=true
      render json:@msg
  end

 def teachers
   @msg.result=true
   @msg.content=@sub_course.teacher_names
  render json: @msg
 end
  private

  def get_sub_course
    @sub_course=SubCourse.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @sub_course
      @msg.content='不存在此课程/服务内容'
      render json:msg
    end
  end
end
