#encoding: utf-8
class StudentCoursesController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy,:creates,:pays,:destroies]
  before_filter :get_student_course , :only=>[:update,:show,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  def create
    @student_course = StudentCourse.new(params[:student_course].strip)
    @msg.content=(@msg.result=@student_course.save) ? @student_course.id :  @student_course.errors.messages
    render :json=>@msg
  end

  # just for update paid
  def update
    @msg.content=@student_course.errors.messages unless @msg.result=@student_course.update_attributes(:paid=>params[:student_course][:paid])
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
      student_course=StudentCourse.new(param[:student_course])
      unless student_course.save
        @msg.result=false
        @msg.content=[] unless @msg.content
        @msg.content<<{:student_id=>param[:student_course][:student_id],:content=>student_course.errors.messages}
      end
    end
    render :json=>@msg
  end

  def pays
    @msg.result=true
    StudentCourse.where(:id=>params[:ids]).update_all(:paid=>params[:paid])
    render :json=>@msg
  end

  def destroies
    @msg.result=true
    StudentCourse.where(:id=>params[:ids]).destroy_all
    render :json=>@msg
  end

  private

  def get_student_course
    @student_course=StudentCourse.find_by_id(params[:id].strip)
  end

  def render_nil_msg
    unless @student_course
      @msg.content='不存在此学生选课'
      render :json=>@msg
    end
  end
end
