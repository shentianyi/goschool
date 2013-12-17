#encoding: utf-8
class HomeworksController < ApplicationController
  before_filter :init_message ,:only=>[:show,:create,:update,:destroy]
  before_filter :get_homework,:only=>[:show,:update,:destroy]
  before_filter :render_nil_msg , :only=>[:edit,:update,:destroy]
  before_filter :require_user_as_teacher, :only=>[:index,:create,:teacher,:update,:destroy]

  layout 'homework'
 
  def create
    attach=params[:homework].slice(:attach)[:attach] if params[:homework].has_key?(:attach)
    @homework = Homework.new(params[:homework].except(:attach))
    Attachment.add(attach,@homework)
    @msg.content=(@msg.result=@homework.save) ? @homework.id :  @homework.errors.messages
    render :json=>@msg
  end

  def teacher
    if @teacher_course=TeacherCourse.where(id:params[:id],user_id:current_user.id).first
      @homework_type=HomeworkType::TEACHER
      if params.has_key?(:menu_type)
        @menu_type=params[:menu_type].to_i
        @homeworks=get_homeworks_by_type(@homework_type,@menu_type) 
      end
      if params[:ajax]
        render partial:'menu_item'
      else
        @sub_course=@teacher_course.sub_course
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

  def get_homeworks_by_type homework_type,menu_type
    if HomeworkType.include?(homework_type)
      case homework_type
      when HomeworkType::TEACHER
        @teacher_course.homeworks.where(HomeworkTeacherMenuType.condition(menu_type)).all
      when HomeworkType::Student
        @teacher_course.homeworks.where(HomeworkTeacherMenuType.condition(menu_type)).all
      end
    else
    []
    end
  end

end
