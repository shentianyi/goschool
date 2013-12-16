#encoding: utf-8
class HomeworksController < ApplicationController
  before_filter :init_message ,:only=>[:show,:create,:update,:destroy]
  before_filter :get_homework,:only=>[:show,:update,:destroy]
  before_filter :render_nil_msg , :only=>[:edit,:update,:destroy]
  before_filter :require_user_as_teacher, :only=>[:index,:create,:teacher,:update,:destroy]

  layout 'homework'
  # def index
  # @homeworks=Homework.all
  # end
  def create
    attach=params[:homework].slice(:attach)[:attach] if params[:homework].has_key?(:attach)
    @homework = Homework.new(params[:homework].except(:attach))
    Attachment.add(attach,@homework)
    @msg.content=(@msg.result=@homework.save) ? @homework.id :  @homework.errors.messages
    render :json=>@msg
  end

  # homeworks/teacher?course=1&cate=100&sub=1
  def teacher
    if @teacher_course=TeacherCourse.where(id:params[:id],user_id:current_user.id).first
      if params[:ajax]
        @homework_titles=@teacher_course.homework.where(HomeworkTeacherMenuType.condition(params[:type].to_i)).all
        render partial:'menu_item'
      else
        @menus=  HomeworkTeacherMenuType.generate_menu
      end
    else
      error_page_404
    end
  end

  def update
    @msg.content=@homework.errors.messages unless @msg.result=@homework.update_attributes(params[:homework])
    render :json=>@msg
  end

  def destroy
    @homework.destroy
    @msg.result=true
    render :json=>@msg
  end

  private

  def get_homework
    @homework=Homework.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @homework
      @msg.content='不存在此作业'
      render :json=>@msg
    end
  end

end
