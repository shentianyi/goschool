#encoding: utf-8
class StudentHomeworksController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_student_homework , :only=>[:update,:edit,:show,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  before_filter :require_user_as_student,:only=>[:create,:edit]
  skip_before_filter :require_user_as_employee
  def create
    attach=params[:student_homework].slice(:attach)[:attach] if params[:student_homework].has_key?(:attach)
    @student_homework=StudentHomework.new(params[:student_homework].except(:attach))
    Attachment.add(attach,@student_homework)
    @student_homework.student=current_logininfo.student
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
    attach=params[:student_homework].slice(:attach)[:attach] if params[:student_homework].has_key?(:attach)
    if @msg.result=@student_homework.update_attributes(params[:student_homework].except(:attach))
      @msg.content=true
      Attachment.add(attach,@student_homework)
    else
    @msg.content=@student_homework.errors.messages
    end
    render :json=>@msg
  end

  def destroy
    @student_homework.destroy
    @msg.result=true
    render :json=>@msg
  end

  def submit_calculate
    @total=StudentHomework.where(student_id:params[:id]).count
    @intime_total=StudentHomework.joins(:homework).where('student_homeworks.submited_time<=homeworks.deadline').where(student_id:params[:id]).count
    render json:[@intime_total,@total]
  end

  def scores
    render json: StudentHomework.scores(params[:id],params[:sid]).map{|sh| {time:sh.time.to_milli,score:sh.score}}
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
