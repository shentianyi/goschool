#encoding: utf-8
class TeachersController < ApplicationController
  # teacher index
  def index
    # teacher=current_user.user -- at last use this
    teacher=User.find(params[:id]) # for test
    @courses=TeacherCoursePresenter.init_presenters(teacher.sub_courses.all,teacher.id)
    render :json=>@courses.map{|course| course.unmark_number }# for test
  end

  def schedules
    @msg=Msg.new(result:true)
    params[:teacher_id]=session[:teacher_id] || params[:teacher_id]
    @msg.object=SchedulePresenter.init_json_presenters( Schedule.by_teacher_date(params).all)
    render :json=>@msg
  end

  def fast_search
    items=[]
    Redis::Search.query('User', params[:q], :conditions => {:tenant_id => current_tenant.id,:is_teacher=>true}).each do |item|
      items<<{id:item['id'],name:item['name'],email:item['email']}
    end
    render json:items
  end
end
