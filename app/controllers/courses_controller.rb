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
    @msg.object={:Course=>@course,:sub_courses=>@course.sub_courses}
    render :json=>@msg
  end

  def create
    tags=params[:Course].slice(:tags).strip
    subs=params[:Course].slice(:subs).strip
    @course = current_tenant.courses.build(params[:Course].except(:subs).except(:tags).strip)
    @course.add_sub_courses(subs[:subs]) if subs.size>0
    unless @msg.result=@course.save
    @msg.content=@course.errors.messages
    else
      @msg.content=@course.id
      @course.add_tags(tags[:tags]) if tags.size>0
    end
    render :json=>@msg
  end

  def update
    tags=params[:Course].slice(:tags).strip
    unless @msg.result=@course.update_attributes(params[:Course].strip)
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
    @teachers=@course.course_teachers.collect{|teacher| TeacherCoursePresenter.new(teacher)}
  end
  
  def students
    @students=@course.course_students.collect{|student|  StudentCoursePresenter.new(student)}
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
