#encoding: utf-8
class StudentHomeworksController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_student_homework , :only=>[:update,:edit,:show,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  before_filter :require_user_as_student,:only=>[:create,:edit]
  skip_before_filter :require_user_as_employee
  def create
    @student_homework=StudentHomework.new(params[:student_homework])
    @student_homework.student=current_user.student
    @student_homework.submited_time=Time.now
    @msg.content=(@msg.result=@student_homework.save) ? @student_homework.id :  @student_homework.errors.messages
    render :json=>@msg
  end

  def show
    render :json=>@student_homework
  end
  
  def edit
    render partial:'edit'
  end

  def update
    if params[:student_homework].has_key?(:score)
      params[:student_homework][:marked]=true
      params[:student_homework][:marked_time]=Time.now
    end
    @msg.content=@student_homework.errors.messages unless @msg.result=@student_homework.update_attributes(params[:student_homework])
    if params[:student_homework].has_key?(:score) && @msg.result
    @msg.content=true # if marked
    end
    render :json=>@msg
  end

  def destroy
    @student_homework.destroy
    @msg.result=true
    render :json=>@msg
  end

  private

  def init_message
    @msg=Msg.new
  end

  def get_student_homework
    @student_homework=StudentHomework.accessible_by(current_ability).find_by_id(params[:id])
  end

  def render_nil_msg
    unless @student_homework
      @msg.content='不存在此学生作业'
      render :json=>@msg
    end
  end

end
