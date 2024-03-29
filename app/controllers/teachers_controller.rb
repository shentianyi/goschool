#encoding: utf-8
class TeachersController < ApplicationController
  skip_load_and_authorize_resource
  before_filter :require_user_as_teacher, :only=>[:index]
  skip_before_filter :require_user_as_employee
  layout 'homepage'
  def index
    @active_left_aside='homepage'
    @teacher=current_logininfo.user
    @courses=TeacherCoursePresenter.init_presenters(TeacherCourse.detail_by_teacher(@teacher.id).all)
  end

  def schedules
    @msg=Msg.new(result:true)
    params[:teacher_id]=session[:teacher_id] || params[:teacher_id]
    @msg.object=SchedulePresenter.init_json_presenters( Schedule.by_teacher_date(params).all)
    render :json=>@msg
  end

  def fast_search
    items=[]
    Redis::Search.complete('User', params[:q], :conditions => {:tenant_id => current_tenant.id,:is_teacher=>true}).each do |item|
      items<<{id:item['id'],name:item['name'],info:item['email']}
    end
    render json:items
  end
end
