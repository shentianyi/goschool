#encoding: utf-8
class CoursesController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_course,:only=>[:update,:edit,:destroy]
  before_filter :render_nil_msg , :only=>[:edit,:update,:destroy]
  def index
    render :json=> Course.all
  end

  def edit
    @msg.result=true
    @msg.object={:course=>@course,:sub_courses=>@course.sub_courses}
    render :json=>@msg
  end

  def create
    tags=params[:course].slice(:tags).strip
    subs=params[:course].slice(:subs).strip
    @course = current_tenant.courses.build(params[:course].except(:subs).except(:tags).strip)
    @course.add_sub_courses(subs[:subs]) if subs.size>0
    unless @msg.result=@course.save
    @msg.content=@course.errors.messages
    else
      @course.add_tags(tags[:tags]) if tags.size>0
    end
    render :json=>@msg
  end

  def update
    tags=params[:course].slice(:tags).strip
    unless @msg.result=@course.update_attributes(params[:course].strip)
    @msg.content=@course.errors.messages
    else
      @course.add_tags(tags[:tags]) if tags.size>0
    end
    render :json=>@msg
  end

  def destroy
    @course.destroy
    @msg.result=true
    render :json=>@msg
  end

  def list_search
    c=[]
    ['Course','SubCourse'].each_with_index do |t,i|
      c[i]= Redis::Search.query(t, params[:q], :conditions => {:tenant_id => current_tenant.id})
    end
    items=[]
    (c[0].slice(0,6)+c[1].sclie(0,4)).each do |item|
      items<<{:name=>item['title'],:content=>item['name'],:type=>item['type'],:id=>item['type']}
    end
    render :json=>items
  end

  private

  def get_course
    @course=Course.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @course
      @msg.content='不存在此课程'
      render :json=>msg
    end
  end
end
