#encoding: utf-8
class HomeworksController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_homework,:only=>[:show,:update,:destroy]
  before_filter :render_nil_msg , :only=>[:edit,:update,:destroy]
  skip_before_filter :require_user_as_employee
  before_filter :require_user_as_teacher, :only=>[:create,:update,:destroy]

  layout 'bbs'
  def index
    @homework_active=true
    if current_user.is_teacher?
      teacher_index
    elsif current_user.is_student?
      student_index
    else
      error_page_404
    end
  end

  def create
    attach=params[:homework].slice(:attach)[:attach] if params[:homework].has_key?(:attach)
    @homework = Homework.new(params[:homework].except(:attach))
    Attachment.add(attach,@homework)
    @msg.content=(@msg.result=@homework.save) ? @homework.id :  @homework.errors.messages
    render :json=>@msg
  end

  def show
    @homework_acitve=true
    if   @homework
      if current_user.is_teacher?
        teacher_show
      elsif current_user.is_student?
        student_show
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

  def list
    @type=params[:type].to_i
    get_homeworks(@type)
    render partial:'menu_item'
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

  def get_homeworks menu_type
    @homeworks =if current_user.is_teacher?
      Homework.by_type({id:params[:id],menu_type:menu_type})
    elsif current_user.is_student?
       StudentHomework.by_type({id:params[:id],menu_type:menu_type,student_id:current_student_id,sub_course_id:params[:sid]})
      else
          error_page_404
    end
  end

  def teacher_index
    if @teacher_course=TeacherCourse.by_teacher(params[:id],current_user.id)
      @sub_course=@teacher_course.sub_course
      session[:course_id]=@sub_course.course_id
      session[:teacher_course_id]=@teacher_course.id
      @menus=  HomeworkTeacherMenuType.generate_menu
      render 'teacher_index'
    else
      error_page_404
    end
  end

  def student_index
    if @student_course=StudentCourse.by_student(params[:id],current_student_id)
      session[:course_id]=params[:id]
      @sub_courses=@student_course.disfault_sub_cousres.all
      @sub_course_id=params[:sid]
      @menus=  HomeworkStudentMenuType.generate_menu
      render 'student_index'
    else
      error_page_404
    end
  end

  def teacher_show
    @homework=TeacherHomeworkPresenter.new(@homework)
    @student_homeworks=StudentHomeworkPresenter.init_presenters(StudentHomework.detail_by_homework_id(@homework.id).all)
    render partial:'teacher_homework'
  end

  def student_show
    @homework=TeacherHomeworkPresenter.new(@homework)
    if sh=StudentHomework.detail_by_homework_id(@homework.id,current_student_id).first
      @student_homework=StudentHomeworkPresenter.new(sh)
    end
    render partial:'student_homework'
  end
end
