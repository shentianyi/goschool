#encoding: utf-8
class TeacherCoursesController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_teacher_course , :only=>[:update,:show,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  def create
    @teacher_course = TeacherCourse.new(params[:teacher_course])

  end

  def update
    @teacher_course = TeacherCourse.find(params[:id])

  end

  def destroy
    @teacher_course = TeacherCourse.find(params[:id])
    @teacher_course.destroy
  end

  private

  def get_teacher_course
    @course=Course.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @course
      @msg.content='不存在此课程'
      render :json=>msg
    end
  end
end
