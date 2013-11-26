class StudentCoursesController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy,:creates,:updates,:destroies]
  before_filter :get_student_course , :only=>[:update,:show,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  def create
    @student_course = StudentCourse.new(params[:student_course].strip)
    unless @msg.result=@student_course.save
    @msg.content=@student_course.errors.messages
    end
    render :json=>@msg
  end

  # just for update paid
  def update
    unless @msg.result=@student_course.update_attributes(params[:student_course].strip.slice(:paid))
    @msg.content=@student_course.errors.messages
    end
    render :json=>@msg
  end

  def destroy
    @student_course.destroy
    @msg.result=true
    render :json=>@msg
  end
  
  def creates
    @msg.result=true
    params[:student_courses].each do |param|
      student_course=StudentCourse.new(param)
      unless student_course.save
        @msg.result=false
	@msg.content=[] unless @msg.content
	@msg.content<<{:student_id=>param[:student_id],:content=>student_course.errors.messages}
      end 
    end
    render :json=>@msg
  end

  def updates
    @msg.result=true
    params[:student_courses].each do |param|
      unless student_course.update_attributes(params[:student_course].strip.slice(:paid))
        @msg.result=false
	@msg.content=[] unless @msg.content
	@msg.content<<{:id=>param[:id],:content=>student_course.errors.messages}
      end if student_course=StudentCourse.find_by_id(param[:id])
    end
    render :json=>@msg
  end

  def destroies
    @msg.result=true
    params[:ids].each do |id|
     student_course.destroy if student_course=StudentCourse.find_by_id(param[:id])
    end
    render :json=>@msg
  end

  private

  def get_student_course
    @student_course=StudentCourse.find_by_id(params[:id].strip)
  end

  def render_nil_msg
    unless @student_course
      @msg.content='不存在此学生选课'
      render :json=>msg
    end
  end
end
