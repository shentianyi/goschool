#encoding: utf-8
class CoursesController < ApplicationController
  before_filter :init_message ,:only=>[:edit,:create,:update,:destroy]
  before_filter :get_course,:only=>[:show,:update,:edit,:destroy]
  before_filter :render_nil_msg , :only=>[:edit,:update,:destroy]

  def show
    @course_presenter=CoursePresenter.new(@course)
    case params[:part]
     when 'teachers'
       teachers()
     when 'recommendations'
	 # recommendations()
    else
	students()
	@partal='students'
    end	
    @partial||=params[:part]
    render :partial=>@partial if params[:ajax] 
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
    @course.subs=subs[:subs]
    @course.tags=tags
    unless @msg.result=@course.save
    @msg.content=@course.errors.messages
    else
      @msg.content=@course.id
    end
    render :json=>@msg
  end

  def update
    @course.tags=params[:course].slice(:tags).strip
    unless @msg.result=@course.update_attributes(params[:course].strip)
    @msg.content=@course.errors.messages
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
    total=10
    l=[6,4]
    ['Course','SubCourse'].each_with_index do |t,i|
      c[i]= Redis::Search.query(t, params[:q], :conditions => {:tenant_id => current_tenant.id})
    end
    items=[]
    
    l[0]=c[0].count if c[0].count<l[0]
    l[1]=total-l[0]
    
    (c[0].slice(0,l[0])+c[1].slice(0,l[1])).each do |item|
      items<<{:name=>item['title'],:content=>item['name'],:type=>item['type'],:id=>item['id']} if(item['is_default']=='false' || item['is_default'].nil?)
    end
    render :json=>items
  end

  private

  def teachers
    @teachers=TeacherCoursePresenter.init_presenters(@course.course_teachers)
  end
  
  def students
    @teachers=TeacherCoursePresenter.init_presenters(@course.course_students)
  end

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
